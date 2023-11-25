#!/usr/bin/env ruby

require_relative '../lib/activity_logger.rb'
require_relative '../lib/file_activity_generator.rb'
require_relative '../lib/network_activity_generator.rb'
require_relative '../lib/process_activity_generator.rb'

OUTPUT_DIRECTORY = 'generated_activity'
#process activity constants
PROCESS_TO_START = '/bin/ls'
PROCESS_ARGS = ['-l']
#file activity constants
TEST_FILE_PATH = 'cromulent_doodle'
TEST_FILE_TYPE = 'txt'
#network activity constants
DESTINATION_ADDRESS = '8.8.8.8'
DESTINATION_PORT = '53'
NETWORK_DATA = 'Test message'

file_activity_generator = FileActivityGenerator.new(OUTPUT_DIRECTORY, $PROGRAM_NAME, TEST_FILE_TYPE)
activity_logger = ActivityLogger.new(OUTPUT_DIRECTORY)
network_activity = NetworkActivityGenerator.new
process_activity = ProcessActivityGenerator.new

process_activity.start_process(PROCESS_TO_START, PROCESS_ARGS, activity_logger)
file_activity_generator.create_file(TEST_FILE_PATH, activity_logger)
file_activity_generator.modify_file(TEST_FILE_PATH, activity_logger)
file_activity_generator.delete_file(TEST_FILE_PATH, activity_logger)
network_activity.generate_network_activity(DESTINATION_ADDRESS, DESTINATION_PORT, NETWORK_DATA, activity_logger)
