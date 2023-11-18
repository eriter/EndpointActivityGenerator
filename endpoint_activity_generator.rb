require 'fileutils'

class EndpointActivityGeneration
    def initialize
        @output_dir = 'activity_generation_log'
        FileUtils.mkdir_p(@output_dir)
    end

    def start_process(executable_path, arguments = [])
        command = "#{executable_path} #{arguments.join(' ')}"
        process = IO.popen(command)
    end
end

PROCESS_TO_START = "/bin/ls"

activity_generator = EndpointActivityGeneration.new

activity_generator.start_process(PROCESS_TO_START)