Aws.config.update({
                      region: ENV['S3_REGION'],
                      credentials: Aws::Credentials.new(ENV['ACCESS_KEY_ID'], ENV['SECRET_ACCESS_KEY']),
                  })