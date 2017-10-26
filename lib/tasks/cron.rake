namespace :cron do
	
  desc "Send account emails"
  task deliver_email: :environment do
  	ApplicationMailer.send_ready_emails
  end

  desc "Converts videos"
  task convert_video: :environment do
    ruby "#{ENV['HOME']}/smart-tools/lib/video_converter.rb"
  end

  desc "Check ConverterQueue"
  task conver_videos_queue: :environment do
  	ConverterQueuer.retrieve_message_from_converter
  end

  desc deliver_email_queu: :environment do
  	ApplicationMailer.retrieve_message_from_mailer
  end
end