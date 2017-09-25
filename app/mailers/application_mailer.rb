class ApplicationMailer < ActionMailer::Base
  default from: 'grupo1.cloud201720@gmail.com'
  def welcome(user)
    mail(to: user, subject: 'Bienvenido a SmartTools!')
  end

  def video_ready(user)
  	mail(to: user, subject: 'Su video ha sido convertido!')
  end

  def self.send_ready_emails
	#connect = Mysql2::Client.new(:host => "#{ENV['SMART_TOOLS_DB_HOST']}", :username => "#{ENV['SMART_TOOLS_DB_USER']}", :password => "#{ENV['SMART_TOOLS_DB_PASSWD']}", :database => "#{ENV['SMART_TOOLS_DB_NAME']}")
	#connect = Mysql2::Client.new(:host => , :username => "smarttools", :password => "smarttools", :database => "smarttools")
	#connect = Mysql2.new("smarttools.ckojm8kxu6a7.us-east-1.rds.amazonaws.com", "smarttools", "smarttools", "smarttools")
	#result = connect.query("SELECT correo_concursante FROM video WHERE estado=2")
	#Aca debe ir el filtro de conexiona  la BD
	@result = Video.where(estado: 2).take
	puts @result
	if @result
		#@result = ['grupo1.cloud201720@gmail.com']
		@result.each do |x| 
			puts 'Sending email to '+x
			video_ready(x).deliver
		end
	end
	#connect.close
  end

end