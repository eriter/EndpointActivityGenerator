require 'fileutils'
require 'logger'
require 'yaml'

class EndpointActivityGeneration
    def initialize
      @output_dir = 'activity_generation_log'
      FileUtils.mkdir_p(@output_dir)
      @logger = Logger.new(File.join(@output_dir, 'activity_log.yml'))
    end

    def log_activity(activity_type, details)
      log_entry = {
        'timestamp' => Time.now.utc,
        'activity_type' => activity_type
      }

      log_entry.merge!(details)
      @logger.info(log_entry.to_yaml)
    end


    def start_process(executable_path, arguments = [])
      command = "#{executable_path} #{arguments.join(' ')}"
      process_id = Process.spawn(command)


      username = ENV['USER']
      details = {
        'username' => username,
        'process_name' => File.basename(executable_path),
        'process_command_line' => command,
        'process_id' => process_id
      }

      log_activity('process_start', details)
    end
end

PROCESS_TO_START = "/bin/ls"

activity_generator = EndpointActivityGeneration.new

activity_generator.start_process(PROCESS_TO_START, ['-l'])
