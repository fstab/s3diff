#!/usr/bin/ruby

# read config.rb
require File.expand_path(File.dirname(__FILE__) + '/config')

# load AWS API for Ruby
s3 = AWS::S3.new

###############################################################################
# Step 0: Parse command line arguments
###############################################################################

if ARGV.length != 2
  puts "Usage: s3diff /local/path s3://bucket/path"
  exit -1
end

if ! File.directory?(ARGV[0])
  puts "#{ARGV[0]}: Directory not found."
  exit -1
end

s3pathMtch = /s3:\/\/([^\/]+)\/(.+)/.match(ARGV[1])

if s3pathMtch.length != 3
  puts "#{ARGV[1]}: Not a valid S3 locator."
  exit -1
end

bucket = s3pathMtch[1]
prefix = s3pathMtch[2].gsub(/\/*$/, '')
local_dir = ARGV[0].gsub(/\/*$/, '')

###############################################################################
# Step 1: Scan S3 content and compare with local content
###############################################################################

scanned_local_files = []

objectCollection = s3.buckets[bucket].objects
prefix.split('/').each() do |prefixDir|
  objectCollection = objectCollection.with_prefix(prefixDir + '/', :append)
end

objectCollection.each() do |object|
  # relative_object_key is the object key without the prefix
  relative_object_key = object.key.dup
  relative_object_key[prefix] = ''
  local_file = local_dir + relative_object_key
  scanned_local_files << local_file
  if ! File.exist?(local_file) then
    puts object.key + ": Does not exist on local disk."
    next
  end
  if ! File.file?(local_file) then
    puts object.key + ": Is stored as an object on S3, but is a directory on local disk."
    next
  end
  etag = object.etag.delete('"')
  local_md5 = Digest::MD5.file(local_file).hexdigest
  if local_md5 != etag then
    puts object.key + ": Checksum on local disc differs from checksum on S3."
  end
end

###############################################################################
# Step 2: Report local files that were not on S3
###############################################################################

local_files = Dir.glob("#{local_dir}/**/*")

(local_files - scanned_local_files).each() do |file|
  if File.file?(file)
    puts file + ': Does not exist on S3.'
  end
end

