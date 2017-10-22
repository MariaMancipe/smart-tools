require 'aws-sdk-sqs'  # v2: require 'aws-sdk'

def send_message_to_queue(mess)
	sqs = Aws::SQS::Client.new(
		region: 'us-east-1',
		access_key_id: ENV['AWS_ACCESS_KEY_ID'],
		secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
	)
	message_result = sqs.send_message(
		queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/CloudSQS', 
		message_body: mess,
	#	message_attributes: {
	#      "Title" => {
	#        string_value: "The Whistler",
	#        data_type: "String"
	#      }
    #	}
    )
	puts message_result.message_id
end

def retrieve_message
	sqs = Aws::SQS::Client.new(
		region: 'us-east-1',
		access_key_id: ENV['AWS_ACCESS_KEY_ID'],
		secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
	)
	receive_message_result = sqs.receive_message({
	  queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/CloudSQS', 
	  #message_attribute_names: ["All"], # Receive all custom attributes.
	  max_number_of_messages: 1, # Receive at most one message.
	  wait_time_seconds: 0 # Do not wait to check for the message.
	})
	#puts receive_message_result.body
	# Display information about the message.
	# Display the message's body and each custom attribute value.
	receive_message_result.messages.each do |message|
	  puts message.body 

	  # Delete the message from the queue.
	  sqs.delete_message({
	    queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/CloudSQS',
	    receipt_handle: message.receipt_handle    
	  })
	end
end

retrieve_message
