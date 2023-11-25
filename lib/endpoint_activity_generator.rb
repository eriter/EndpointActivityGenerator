class EndpointActivityGenerator

    def initialize (output_directory, script_name, file_type)
      @output_dir = output_directory
      @script_name = script_name
      @file_type = file_type
    end

    def create_file(file_path, logger)
      relative_path = File.join(@output_dir, "#{file_path}.#{@file_type}")
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

    def modify_file(file_path, text_to_append = 'reminiscent bells', logger)
      relative_path = File.join(@output_dir, "#{file_path}.#{@file_type}")
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

    def delete_file(file_path, logger)
      relative_path = File.join(@output_dir, "#{file_path}.#{@file_type}")
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
