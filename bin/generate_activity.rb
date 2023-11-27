#!/usr/bin/env ruby

require 'optparse'
require 'yaml'
require_relative '../lib/activity_logger.rb'
require_relative '../lib/file_activity_generator.rb'
require_relative '../lib/network_activity_generator.rb'
require_relative '../lib/process_activity_generator.rb'

config = YAML.load_file(File.join(File.dirname(__FILE__), '../config.yml'))

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [options]"

  opts.on("-o", "--output DIRECTORY", "Output directory") do |output|
    options[:output_directory] = output
  end

  opts.on("-f", "--file_path PATH", "Test file path") do |file_path|
    options[:test_file_path] = file_path
  end

  opts.on("-t", "--file_type TYPE", "Test file type") do |file_type|
    options[:test_file_type] = file_type
  end

  opts.on("-p", "--process COMMAND", "Process to start") do |process|
    options[:process_to_start] = process
  end
end.parse!

# Override defaults with command line options, if provided
OUTPUT_DIRECTORY = options[:output_directory] || config['output_directory']
# Process activity constants
PROCESS_TO_START = options[:process_to_start] || config['process_to_start']
PROCESS_ARGS = config['process_args']
# File activity constants
TEST_FILE_PATH = options[:test_file_path] || config['test_file_path']
TEST_FILE_TYPE = options[:test_file_type] || config['test_file_type']
# Network activity constants
DESTINATION_ADDRESS = config['destination_address']
DESTINATION_PORT = config['destination_port']
NETWORK_DATA = config['network_data']

# Instantiate activity generators and logger
activity_logger = ActivityLogger.new(OUTPUT_DIRECTORY)
file_activity_generator = FileActivityGenerator.new(OUTPUT_DIRECTORY, $PROGRAM_NAME)
network_activity = NetworkActivityGenerator.new
process_activity = ProcessActivityGenerator.new

# Script activity
process_activity.start_process(PROCESS_TO_START, PROCESS_ARGS, activity_logger)
file_activity_generator.create_file(TEST_FILE_PATH, TEST_FILE_TYPE, activity_logger)
file_activity_generator.modify_file(TEST_FILE_PATH, TEST_FILE_TYPE, activity_logger)
file_activity_generator.delete_file(TEST_FILE_PATH, TEST_FILE_TYPE, activity_logger)
network_activity.generate_network_activity(DESTINATION_ADDRESS, DESTINATION_PORT, NETWORK_DATA, activity_logger)
