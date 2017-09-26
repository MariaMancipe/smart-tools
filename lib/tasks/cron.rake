namespace :cron do
	
  desc "Send account emails"
  task deliver_email: :environment do
  	ApplicationMailer.send_ready_emails
  end

  desc "Converts videos"
  task convert_video: :environment do
    Run ENV[$HOME]/smart-tools/lib/video_converter.rb
  end
end