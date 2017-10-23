# namespace :create_tables do
#   desc "bundle exec rake dynamodb_tables_v1:create_activity_table RAILS_ENV=<ENV>"
#   task :create_tables => :environment do
#     puts "Creating usuarios table in #{Rails.env}\n"
#     create_usuarios_table
#     puts "Completed task\n"
#
#     puts "Creating concursos table in #{Rails.env}\n"
#     create_concursos_table
#     puts "Completed task\n"
#
#     puts "Creating videos table in #{Rails.env}\n"
#     create_videos_table
#     puts "Completed task\n"
#   end
#
#   def create_usuarios_table
#
#     begin
#       result = DynamodbClient.client.create_table(params)
#
#       puts
#
#     rescue Aws::DynamoDB::Errors::ServiceError => error
#       puts 'Unable to create table: usuarios\n'
#       puts "#{error.message}"
#     end
#
#   end
# end