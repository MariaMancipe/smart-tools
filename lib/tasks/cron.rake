namespace :cron do
	
  desc "Send account emails"
  task deliver_email: :environment do
  	ApplicationMailer.send_ready_emails
   end
end