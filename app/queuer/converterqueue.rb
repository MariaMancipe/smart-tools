require 'aws-sdk-sqs'  # v2: require 'aws-sdk'
require 'fileutils'
require 'streamio-ffmpeg'
require 'mysql2'
require 'aws-sdk'

$sqs = Aws::SQS::Client.new(
	region: 'us-east-1',
	access_key_id: ENV['AWS_ACCESS_KEY_ID'],
	secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)

#Crea query para actualizar estado de 0 (por convertir) a 1 (convertido)
def create_query_converted(idVid, url)
	return "UPDATE videos SET estado=1, video_convertido=\'#{url}\' WHERE id=\'#{idVid}"
end

#Crea query para actualizar estado de 1 (convertido) a 2 (mail enviado)
def create_query_mailed(f)
end

#Despues de la conversion, agrega un mensaje a la cola del mailer para que sea entregado.
def push_messages_mailer(idvid, mail)
	message_result = $sqs.send_message(
		queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/MailerQueue', 
		message_body: 'Mail',
		message_attributes: {
	     "Video" => {
	        string_value: idvid,
	        data_type: "String"
	      },
	      "Usermail" => {
	        string_value: mail,
	        data_type: "String"
	      }
    	}
    )
	puts message_result.message_id
end

#Recupera los mensajes de la cola converter para iniciar la conversión de videos
def retrieve_message_from_converter
	receive_message_result = $sqs.receive_message({
	  queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/ConverterQueu', 
	  message_attribute_names: ["All"], # Receive all custom attributes.
	  max_number_of_messages: 1, # Receive at most one message.
	  wait_time_seconds: 0 # Do not wait to check for the message.
	})
	#puts receive_message_result.body
	# Display information about the message.
	# Display the message's body and each custom attribute value.
	receive_message_result.messages.each do |message|
		puts message
		idVid = message.message_attributes["IDVid"]["string_value"]
		rutaVid = message.message_attributes["URL"]["string_value"]
		usermail = message.message_attributes["Usermail"]["string_value"]
		puts "ID: #{idVid}"
		puts "URL: #{rutaVid}"
		puts "Usermail: #{usermail}"  

		#Realiza la conversión del video
		nuevo_path = convert_to_mp4(rutaVid)

		#Conexion a la base de datos para actualizar el estado del video
		#connect = Mysql2::Client.new(:host => "#{ENV['SMART_TOOLS_DB_HOST']}", :username => "#{ENV['SMART_TOOLS_DB_USER']}", :password => "#{ENV['SMART_TOOLS_DB_PASSWD']}", :database => "#{ENV['SMART_TOOLS_DB_NAME']}", :port => 3306)
  		#connect.query(create_query_converted(IDVid, nuevo_path))

  		#connect.close

  		#Envio de mensaje a la cola de mail para proceso de envio
  		push_messages_mailer(idVid, usermail)
  		
		# Delete the message from the queue.
		$sqs.delete_message({
		  queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/ConverterQueu',
		  receipt_handle: message.receipt_handle    
		})
	end
end


# Prueba de envio
def send_message_to_converter_queue(mess, idVid, vidurl, usermail)
	message_result = $sqs.send_message(
		queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/ConverterQueu', 
		message_body: mess,
		message_attributes: {
	      "IDVid" => {
	        string_value: idVid,
	        data_type: "String"
	      },
	      "URL" => {
	        string_value: vidurl,
	        data_type: "String"
	      },
	      "Usermail" => {
	        string_value: usermail,
	        data_type: "String"
	      }
    	}
    )
	puts message_result.message_id
end

#--------------------------- VIDEO CONVERTER-UPLOADER-DOWNLOADER -------------------------------

$s3 = Aws::S3::Resource.new(
		region: ENV['S3_REGION'],
		access_key_id: ENV['ACCESS_KEY_ID'],
		secret_access_key: ENV['SECRET_ACCESS_KEY']
)

def convert_to_mp4(path)
	puts "convert to mp4 #{ENV['VIDEO_UPLOAD']+path}"
	Dir.mkdir("#{ENV['VIDEO_UPLOAD']}") unless File.exist?("#{ENV['VIDEO_UPLOAD']}")
	Dir.mkdir("#{ENV['VIDEO_CONVERTED']}") unless File.exist?("#{ENV['VIDEO_CONVERTED']}")
	download_video(path)
	movie = FFMPEG::Movie.new("#{ENV['VIDEO_UPLOAD']+path}")
	basename = File.basename(path,File.extname(path))
	new_path = ENV['VIDEO_CONVERTED'] + basename
	movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 10 -threads 10))
	upload_video("#{basename}.mp4")
	delete_files("#{ENV['VIDEO_UPLOAD']+path}","#{new_path}.mp4")
	new_path = '';
	return new_path
end

def download_video(path)
	$s3.bucket(ENV['S3_BUCKET']).object("#{ENV['S3_UPLOADS_FOLDER']+path}").get(response_target: "#{ENV['VIDEO_UPLOAD']+path}")
end

def upload_video(path)
	obj = $s3.bucket(ENV['S3_BUCKET']).object("#{ENV['S3_CONVERTED_FOLDER']+path}")
	obj.upload_file("#{ENV['VIDEO_CONVERTED']+path}")
end

def delete_files(upload,converted)
	File.delete(upload)
	File.delete(converted)
end


retrieve_message_from_converter
