require 'streamio-ffmpeg'
require 'mysql2'
require 'fileutils'

$original = "#{ENV['VIDEO_ORIGINAL']}"
$converted = "#{ENV['VIDEO_CONVERTED']}"
$upload = "#{ENV['VIDEO_UPLOAD']}"

def move_upload_to_original
  Dir.entries($upload).select {|f| FileUtils.move $upload+f, $original + File.basename(f) unless File.directory?(f)}
end

def convert_to_mp4(path)
  puts "convert to mp4 #{path}"
  movie = FFMPEG::Movie.new(path)
  new_path = $converted+ File.basename(path,File.extname(path))
  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 10 -threads 10))

end

def search_files
  puts "entra"
  Dir.mkdir($original) unless File.exist?($original)
  Dir.mkdir($converted) unless File.exist?($converted)
  Dir.entries($upload).select {|f| convert_to_mp4($upload+f) unless File.directory?(f)}
  mark_state
  move_upload_to_original
end

def create_query(f)
  @split = f.split("__")
  converted = File.basename(f, File.extname(f))+".mp4"
  return "UPDATE videos SET estado=1, video_convertido=\'#{ENV['VIDEO_CONVERTED'] + converted}\', video_original=\'#{ENV['VIDEO_ORIGINAL']+ f}\' WHERE nombre=\'#{@split.at(0)}\' AND id=#{@split.at(1)}"
end

def mark_state
  connect = Mysql2::Client.new(:host => "#{ENV['SMART_TOOLS_DB_HOST']}", :username => "#{ENV['SMART_TOOLS_DB_USER']}", :password => "#{ENV['SMART_TOOLS_DB_PASSWD']}", :database => "#{ENV['SMART_TOOLS_DB_NAME']}", :port => 3306)
  Dir.entries($upload).select {|f|  connect.query(create_query(f)) unless File.directory?(f)}
  connect.close
end

search_files
