require 'streamio-ffmpeg'
require 'mysql2'
require 'fileutils'

$original = "#{ENV['VIDEO_ORIGINAL']}"
$converted = "#{ENV['VIDEO_CONVERTED']}"
$upload = "#{ENV['VIDEO_UPLOAD']}"

def convert_to_mp4_five(path)
  puts "convert to mp4 #{path}"
  movie = FFMPEG::Movie.new(path)
  converted = "./public/video/converted/"
  new_path = File.basename(path)
  new_path = $converted+ new_path[0,new_path.length-4]
  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 5 -threads 5))
end

def convert_to_mp4_ten(path)
  puts "convert to mp4 #{path}"
  movie = FFMPEG::Movie.new(path)
  converted = "./public/video/converted/"
  new_path = File.basename(path)
  new_path = $converted+ new_path[0,new_path.length-4]
  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 10 -threads 10))
end

def convert_to_mp4_twenty(path)
  puts "convert to mp4 #{path}"
  movie = FFMPEG::Movie.new(path)
  converted = "./public/video/converted/"
  new_path = File.basename(path)
  new_path = $converted+ new_path[0,new_path.length-4]
  movie.transcode("#{new_path}.mp4", %w(-acodec aac -vcodec h264 -strict -2 -threads 20 -threads 20))
end

def search_files
  Dir.mkdir($original) unless File.exist?($original)
  Dir.mkdir($converted) unless File.exist?($converted)
  start = Time.now
  Dir.entries($upload).select {|f| convert_to_mp4_five($upload+f) unless File.directory?(f)}
  last = Time.now
  puts "5 Threads in #{last-start}"

  start = Time.now
  Dir.entries($upload).select {|f| convert_to_mp4_ten($upload+f) unless File.directory?(f)}
  last = Time.now
  puts "10 Threads in #{last-start}"

  start = Time.now
  Dir.entries($upload).select {|f| convert_to_mp4_twenty($upload+f) unless File.directory?(f)}
  last = Time.now
  puts "20 Threads in #{last-start}"
end

search_files