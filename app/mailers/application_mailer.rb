require 'mysql2'
class ApplicationMailer < ActionMailer::Base
  default from: 'grupo1.cloud201720@gmail.com'
  def welcome(user)
    mail(to: user, subject: 'Bienvenido a SmartTools!')
  end

  def video_ready(user)
  	mail(to: user, subject: 'Su video ha sido convertido!')
  end

  def self.query_unmailed_videos
  	#return "UPDATE videos SET estado=2 WHERE estado =1"
  	return "select id, correo_concursante from videos where estado = 1"
  end

  def self.change_state_mailed_vids(id)
  	#return "UPDATE videos SET estado=2 WHERE estado =1"
  	return "UPDATE videos SET estado = 2 where id="+id
  end

  def self.send_ready_emails
	ids = Array.new
	corrs = Array.new
	connect = Mysql2::Client.new(:host => "smarttools.ckojm8kxu6a7.us-east-1.rds.amazonaws.com", :username => "smarttools", :password => "smarttools", :database => "smarttools", :port => 3306)
	puts ' CONNECTED'
	result = connect.query(query_unmailed_videos)
	if result
		#@result = ['grupo1.cloud201720@gmail.com']
		result.each(:as => :array) do |x| 
			video_ready(x[1].to_s).deliver
			connect.query(change_state_mailed_vids(x[0].to_s))
		end
	end
	connect.close
	#corrs.each { |y| video_ready(y).deliver}
	#connect = Mysql2::Client.new(:host => "smarttools.ckojm8kxu6a7.us-east-1.rds.amazonaws.com", :username => "smarttools", :password => "smarttools", :database => "smarttools", :port => 3306)
	#ids.each { |y| 	connect.query(change_state_mailed_vids(y)) }
	#connect.close
  end

end