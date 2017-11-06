desc "Check ConverterQueue"
task :convert_videos_queue => :environment do
  puts 'Starting pending conversions...'
  require "#{Rails.root}/app/queuer/converterqueue"
	ConverterQueuer.retrieve_message_from_converter
  puts 'Conversion done!'
end

desc "Deliver undelivered mails"
task :deliver_email_queu => :environment do
  require "#{Rails.root}/app/queuer/mailerequeue"
  puts 'Starting email delivery...'
  MailerQueuer.retrieve_message_from_mailer
  puts 'Mail delivered!'
end