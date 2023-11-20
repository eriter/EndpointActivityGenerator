require 'fileutils'
require 'logger'
require 'socket'
require 'yaml'

class EndpointActivityGenerator
    def initialize
      @output_dir = 'generated_activity'
      FileUtils.mkdir_p(@output_dir)
      @logger = Logger.new(File.join(@output_dir, 'activity_log.yml'))
      @script_name = $PROGRAM_NAME
    end

    def log_activity(activity_type, details)
      log_entry = {
        'username' => ENV['USER'],
        'timestamp' => Time.now.utc,
        'activity_type' => activity_type
      }

      log_entry.merge!(details)
      @logger.info(log_entry.to_yaml)
    end

    def start_process(executable_path, arguments = [])
      command = "#{executable_path} #{arguments.join(' ')}"
      process = IO.popen(command)

      details = {
        'process_name' => File.basename(executable_path),
        'process_command_line' => command,
        'process_id' => process.pid
      }

      log_activity('process_start', details)
      process.close
    end

    def create_file(file_path, file_type = 'txt')
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

      log_activity('file_create', details)
      process.close
    end

    def modify_file(file_path, file_type = 'txt', text_to_append = 'reminiscent bells')
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

      log_activity('file_modify', details)
    end

    def delete_file(file_path, file_type = 'txt')
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

      log_activity('file_delete', details)
    end
end

PROCESS_TO_START = "/bin/ls"
TEST_FILE_PATH = "cromulent_doodle"

activity_generator = EndpointActivityGenerator.new

activity_generator.start_process(PROCESS_TO_START, ['-l'])
activity_generator.create_file(TEST_FILE_PATH)
activity_generator.modify_file(TEST_FILE_PATH)
activity_generator.delete_file(TEST_FILE_PATH)
