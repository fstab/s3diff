# Reads the AWS keys from config.yml
# This is taken from the AWS SDK for Ruby sample code. See
# https://github.com/aws/aws-sdk-ruby/blob/master/samples/samples_config.rb

require 'rubygems'
require 'yaml'
require 'aws-sdk'

config_file = File.join(File.dirname(__FILE__),
                        "config.yml")
unless File.exist?(config_file)
  puts <<END
To run s3diff, put your credentials in config.yml as follows:

access_key_id: YOUR_ACCESS_KEY_ID
secret_access_key: YOUR_SECRET_ACCESS_KEY

END
  exit 1
end

config = YAML.load(File.read(config_file))

unless config.kind_of?(Hash)
  puts <<END
config.yml is formatted incorrectly.  Please use the following format:

access_key_id: YOUR_ACCESS_KEY_ID
secret_access_key: YOUR_SECRET_ACCESS_KEY

END
  exit 1
end

AWS.config(config)
