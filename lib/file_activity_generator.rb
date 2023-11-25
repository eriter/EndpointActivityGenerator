require 'fileutils'

class FileActivityGenerator

    def initialize (output_directory, script_name, file_path, file_type)
      @output_dir = output_directory
      @script_name = script_name
      @file_type = file_type
      @relative_path = build_relative_filepath(file_path)
      @full_path = build_full_filepath(@relative_path)
    end

    def create_file(logger)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      FileUtils.touch(@relative_path)

      details = {
        'full_path_to_file' => @full_path,
        'activity_descriptor' => "create",
        'process_name' => @script_name,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_create', details)
    end

    def modify_file(text_to_append = 'reminiscent bells', logger)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      File.open(@relative_path, 'a') { |file| file.puts(text_to_append) }

      details = {
        'full_path_to_file' => @full_path,
        'activity_descriptor' => "modify",
        'process_name' => @script_name,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_modify', details)
    end

    def delete_file(logger)
      process_id = Process.pid
      process_command_line = `ps -p #{process_id} -o command=`

      File.delete(@relative_path)

      details = {
        'full_path_to_file' => @full_path,
        'activity_descriptor' => "delete",
        'process_name' => @script_name,
        'process_command_line' => process_command_line.strip,
        'process_id' => process_id,
      }

      logger.log_activity('file_delete', details)
    end

    private

    def build_relative_filepath(file_path)
      File.join(@output_dir, "#{file_path}.#{@file_type}")
    end

    def build_full_filepath(relative_path)
      File.expand_path(relative_path)
    end
end
