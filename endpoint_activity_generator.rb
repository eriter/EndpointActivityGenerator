require 'yaml'
require_relative 'activity_logger.rb'

class EndpointActivityGenerator
    def initialize
      @output_dir = 'generated_activity'
      @script_name = $PROGRAM_NAME
    end

    def start_process(executable_path, arguments = [], logger)
      command = "#{executable_path} #{arguments.join(' ')}"
      process = IO.popen(command)

      details = {
        'process_name' => File.basename(executable_path),
        'process_command_line' => command,
        'process_id' => process.pid
      }

      logger.log_activity('process_start', details)

      process.close
    end

    def create_file(file_path, file_type = 'txt', logger)
      relative_path = File.join(@output_dir, "#{file_path}.#{file_type}")
      command = "touch #{relative_path}"
      process = IO.popen(command)
      full_path = File.expand_path(relative_path)

      details = {
        'full_path_to_file' => full_path,
        'activity_descriptor' => "create",
        'process_name' => @script_name,
        'process_command_line' => command,
        'process_id' => process.pid,
      }

      logger.log_activity('file_create', details)
      process.close
    end

    def modify_file(file_path, file_type = 'txt', text_to_append = 'reminiscent bells', logger)
      relative_path = File.join(@output_dir, "#{file_path}.#{file_type}")
      full_path = File.expand_path(relative_path)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      File.open(relative_path, 'a') { |file| file.puts(text_to_append) }

      details = {
        'full_path_to_file' => full_path,
        'activity_descriptor' => "modify",
        'process_name' => @script_name,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_modify', details)
    end

    def delete_file(file_path, file_type = 'txt', logger)
      relative_path = File.join(@output_dir, "#{file_path}.#{file_type}")
      full_path = File.expand_path(relative_path)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      File.delete(relative_path)

      details = {
        'full_path_to_file' => full_path,
        'activity_descriptor' => "delete",
        'process_name' => @script_name,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_delete', details)
    end
end

PROCESS_TO_START = "/bin/ls"
PROCESS_ARGS = ['-l']
TEST_FILE_PATH = "cromulent_doodle"
OUTPUT_DIR = 'generated_activity'

activity_generator = EndpointActivityGenerator.new
activity_logger = ActivityLogger.new(OUTPUT_DIR)

activity_generator.start_process(PROCESS_TO_START, PROCESS_ARGS, activity_logger)
activity_generator.create_file(TEST_FILE_PATH, activity_logger)
activity_generator.modify_file(TEST_FILE_PATH, activity_logger)
activity_generator.delete_file(TEST_FILE_PATH, activity_logger)
