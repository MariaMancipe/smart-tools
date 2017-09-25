require 'streamio-ffmpeg'
require 'mysql2'
require 'fileutils'

$original = "#{ENV['VIDEO_ORIGINAL']}"
$converted = "#{ENV['VIDEO_CONVERTED']}"
$upload = "#{ENV['VIDEO_UPLOAD']}"

def move_upload_to_original(path)
  new_path = File.basename(path)
  FileUtils.move path, "#{$original + new_path}"
  #File.rename(path, "#{$original + new_path}")
end

def convert_to_mp4(path)
  puts "convert to mp4 #{path}"
  movie = FFMPEG::Movie.new(path)
  converted = "./public/video/converted/"
  new_path = File.basename(path)
  new_path = $converted+ new_path[0,new_path.length-4]

  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 10 -threads 10))
  move_upload_to_original(path)
end

def search_files

  Dir.mkdir($original) unless File.exist?($original)
  Dir.mkdir($converted) unless File.exist?($converted)
  Dir.entries($upload).select {|f| convert_to_mp4($upload+f) unless File.directory?(f)}
end

def create_query(f)
  @split = f.split("__")
  #@date = @split[3]
  return "UPDATE videos SET estado=2, video_convertido=#{f}, video_original=#{f} WHERE nombre=#{@split.at(0)}"
end

def mark_state
  connect = Mysql2::Client.new(:host => "#{ENV['SMART_TOOLS_DB_HOST']}", :username => "#{ENV['SMART_TOOLS_DB_USER']}", :password => "#{ENV['SMART_TOOLS_DB_PASSWD']}", :database => "#{ENV['SMART_TOOLS_DB_NAME']}", :port => 3306)
  #connect = Mysql2::Client.new(:host => , :username => "smarttools", :password => "smarttools", :database => "smarttools")
  #connect = Mysql2.new("smarttools.ckojm8kxu6a7.us-east-1.rds.amazonaws.com", "smarttools", "smarttools", "smarttools")
  Dir.entries($upload).select {|f| puts create_query(f) unless File.directory?(f)}
  result = connect.query("SELECT * FROM videos")
  result.each {|x| puts x }
  connect.close
end

mark_state
