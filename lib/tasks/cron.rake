namespace :cron do
	
  desc "Send account emails"
  task deliver_email: :environment do
  	ApplicationMailer.send_ready_emails
  end

  task convert_video: :environment do
    Run lib/video_converter.rb
  end
end