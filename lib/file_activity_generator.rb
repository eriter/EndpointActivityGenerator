require 'fileutils'

class FileActivityGenerator

    def initialize (output_directory, script_name)
      @output_dir = output_directory
      @script_name = script_name
    end

    def create_file(file_path, file_type, logger)
      full_path = build_full_filepath(file_path, file_type)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      FileUtils.touch(full_path)

      details = {
        'full_path_to_file' => full_path,
        'activity_descriptor' => "create",
        'process_name' => @script_name,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_create', details)
    end

    def modify_file(file_path, file_type, text_to_append = 'reminiscent bells', logger)
      full_path = build_full_filepath(file_path, file_type)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      File.open(full_path, 'a') { |file| file.puts(text_to_append) }

      details = {
        'full_path_to_file' => full_path,
        'activity_descriptor' => "modify",
        'process_name' => @script_name,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_modify', details)
    end

    def delete_file(file_path, file_type, logger)
      full_path = build_full_filepath(file_path, file_type)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      File.delete(full_path)

      details = {
        'full_path_to_file' => full_path,
        'activity_descriptor' => "delete",
        'process_name' => full_path,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_delete', details)
    end

    private

    def build_full_filepath(file_path, file_type)
      relative_path = File.join(@output_dir, "#{file_path}.#{file_type}")
      File.expand_path(relative_path)
    end
end
