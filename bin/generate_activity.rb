require_relative '../lib/activity_logger.rb'
require_relative '../lib/endpoint_activity_generator.rb'
require_relative '../lib/network_activity_generator.rb'
require_relative '../lib/process_activity_generator.rb'

PROCESS_TO_START = '/bin/ls'
PROCESS_ARGS = ['-l']
TEST_FILE_PATH = 'cromulent_doodle'
OUTPUT_DIRECTORY = 'generated_activity'
DESTINATION_ADDRESS = '8.8.8.8'
DESTINATION_PORT = '53'
NETWORK_DATA = 'Test message'

activity_generator = EndpointActivityGenerator.new(OUTPUT_DIRECTORY, $PROGRAM_NAME)
activity_logger = ActivityLogger.new(OUTPUT_DIRECTORY)
network_activity = NetworkActivityGenerator.new
process_activity = ProcessActivityGenerator.new

process_activity.start_process(PROCESS_TO_START, PROCESS_ARGS, activity_logger)
activity_generator.create_file(TEST_FILE_PATH, activity_logger)
activity_generator.modify_file(TEST_FILE_PATH, activity_logger)
activity_generator.delete_file(TEST_FILE_PATH, activity_logger)
network_activity.generate_network_activity(DESTINATION_ADDRESS, DESTINATION_PORT, NETWORK_DATA, activity_logger)
