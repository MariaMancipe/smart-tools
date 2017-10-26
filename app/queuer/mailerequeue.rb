require 'aws-sdk'  # v2: require 'aws-sdk'
require 'fileutils'
require 'streamio-ffmpeg'
require 'mysql2'

class MailerQueuer < ApplicationMailer
	#Crea query para actualizar estado de 1 (convertido) a 2 (mail enviado)
	def self.create_query_mailed(idVid)
		return "UPDATE videos SET estado=2 WHERE id=\'#{idVid}"
	end

	#Envio de mensaje
	def video_ready(user)
  		mail(to: user, subject: 'Su video ha sido convertido!')
		puts 'Message sent'
	end

	#Recupera los mensajes de la cola converter para iniciar la conversión de videos
	def self.retrieve_message_from_mailer
		sqs = Aws::SQS::Client.new(
			region: 'us-east-1',
			access_key_id: ENV['AWS_ACCESS_KEY_ID'],
			secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
		)
		receive_message_result = sqs.receive_message({
		  queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/MailerQueue', 
		  message_attribute_names: ["All"], # Receive all custom attributes.
		  max_number_of_messages: 1, # Receive at most one message.
		  wait_time_seconds: 0 # Do not wait to check for the message.
		})
		puts receive_message_result.body
		# Display information about the message.
		# Display the message's body and each custom attribute value.
		receive_message_result.messages.each do |message|
			puts message
			idVid = message.message_attributes["Video"]["string_value"]
			usermail = message.message_attributes["Usermail"]["string_value"]
			puts "ID: #{idVid}"
			puts "Usermail: #{usermail}"  

			# Realiza el envío del mensaje
			video_ready(usermail).deliver

			# Conexion a la base de datos para actualizar el estado del video
			#connect = Mysql2::Client.new(:host => "#{ENV['SMART_TOOLS_DB_HOST']}", :username => "#{ENV['SMART_TOOLS_DB_USER']}", :password => "#{ENV['SMART_TOOLS_DB_PASSWD']}", :database => "#{ENV['SMART_TOOLS_DB_NAME']}", :port => 3306)
	  		#connect.query(create_query_mailed(IDVid))
			#connect.close
	  		
			# Delete the message from the queue.
			sqs.delete_message({
			  queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/MailerQueue',
			  receipt_handle: message.receipt_handle    
			})
		end
	end

	#retrieve_message_from_mailer

end