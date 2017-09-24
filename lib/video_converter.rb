require 'streamio-ffmpeg'
require 'mysql3'

$original = "#{ENV['HOME']}/video_original/"
$converted = "#{ENV['HOME']}/video_converted/"
$upload = "#{ENV['HOME']}/video_upload/"

def move_upload_to_original(path)
  new_path = File.basename(path)
  File.rename(path, "./public/video/original/#{new_path}")
end

def convert_to_mp4(path)
  puts "convert to mp4 #{path}"
  movie = FFMPEG::Movie.new(path)
  converted = "./public/video/converted/"
  new_path = File.basename(path)
  new_path = $converted+ new_path[0,new_path.length-4]

  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 1 -threads 1))
  move_upload_to_original(path)
end

def search_files

  Dir.mkdir($original) unless File.exist?($original)
  Dir.mkdir($converted) unless File.exist?($converted)
  Dir.entries($upload).select {|f| convert_to_mp4($upload+f) unless File.directory?(f)}
end

def send_emails

end

def search_emails
  connect = Mysql3::Client.new(:host => "#{ENV['SMART_TOOLS_DB_HOST']}", :username => "#{ENV['SMART_TOOLS_DB_USER']}", :password => "#{ENV['SMART_TOOLS_DB_PASSWD']}", :database => "#{ENV['SMART_TOOLS_DB_NAME']}")
  result = connect.query("SELECT * FROM VIDEO")
  result.each {  |x| puts x }

end

search_files
