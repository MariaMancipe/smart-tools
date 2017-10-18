require 'aws-sdk-sqs'  # v2: require 'aws-sdk'


sqs = Aws::SQS::Client.new(
  region: 'us-west-2',
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  )

sqs.send_message(queue_url: 'https://sqs.us-east-1.amazonaws.com/461044559437/CloudSQS', message_body: 'Hello world')