require 'aws-sdk'

class UploaderQueuer
	
	# Prueba de envio
	def self.send_message_to_converter_queue(mess, idVid, vidurl, usermail)
		sqs = Aws::SQS::Resource.new(
			region: 'us-east-1',
			access_key_id: ENV['AWS_ACCESS_KEY_ID'],
			secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
		)
		message_result = sqs.send_message(
			queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/ConverterQueue',
			message_body: mess,
			message_attributes: {
		      "IDVid" => {
		        string_value: idVid.to_s,
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
end
#send_message_to_converter_queue('Escenario de prueba', '99', 'path/vid.ext', 'jc.ortiz939@uniandes.edu.co')