# config/initializers/carrierwave.rb
# This file is not created by default so you might have to create it yourself.
CarrierWave.configure do |config|

  # Use local storage if in development or test
  # if Rails.env.development? || Rails.env.test?
  #   CarrierWave.configure do |config|
  #     config.storage = :file
  #   end
  # end

  # Use AWS storage if in production
  # if Rails.env.production? || Rails.env.development? || Rails.env.test?
  #   CarrierWave.configure do |config|
  #
  #   end
  # end

  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['SECRET_ACCESS_KEY'],
      region: ENV['S3_REGION'],
      endpoint: 'https://s3.amazonaws.com'
  }
  config.fog_directory = ENV['S3_BUCKET']
  config.fog_public = true
  config.storage = :fog

end