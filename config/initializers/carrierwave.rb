# config/initializers/carrierwave.rb
# This file is not created by default so you might have to create it yourself.
require 'carrierwave/storage/fog'
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

  config.storage = :fog
  config.fog_credentials = {
      :provider               => 'AWS',                             # required
      :aws_access_key_id      => "#{ENV['ACCESS_KEY_ID']}",         # required
      :aws_secret_access_key  => "#{ENV['SECRET_ACCESS_KEY']}",     # required
      :region                 => 'us-east-1'                        # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'smart-tools'                           # required
  #config.fog_host       = 'https://assets.example.com'           # optional, defaults to nil
  #config.fog_public     = false                                  # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end