require 'aws-sdk'

s3 = Aws::S3::Resource.new(
    region: ENV['S3_REGION'],
    access_key_id: ENV['ACCESS_KEY_ID'],
    secret_access_key: ENV['SECRET_ACCESS_KEY']
)

#s3.bucket(ENV['S3_BUCKET']).object('videos/Hola Colombia__9876543__.avi').get(response_target: '/home/ubuntu/Hola Colombia__9876543__.avi')

obj = s3.bucket(ENV['S3_BUCKET']).object('videos/Hola Colombia__9876543__.avi')
obj.upload_file('/home/ubuntu/Hola Colombia__9876543__.avi')
