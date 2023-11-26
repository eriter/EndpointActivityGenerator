require 'fileutils'

class FileActivityGenerator

    def initialize (output_directory, script_name)
      @output_dir = output_directory
      @script_name = script_name
    end

    def create_file(file_path, file_type, logger)
      full_path = build_full_filepath(file_path, file_type)

      perform_file_operation('create', full_path, logger) do
        FileUtils.touch(full_path)
      end
    end

    def modify_file(file_path, file_type, text_to_append = 'reminiscent bells', logger)
      full_path = build_full_filepath(file_path, file_type)

      perform_file_operation('modify', full_path, logger) do
        File.open(full_path, 'a') { |file| file.puts(text_to_append) }
      end
    end

    def delete_file(file_path, file_type, logger)
      full_path = build_full_filepath(file_path, file_type)

      perform_file_operation('delete', full_path, logger) do
        File.delete(full_path)
      end
    end

    private

    def build_full_filepath(file_path, file_type)
      relative_path = File.join(@output_dir, "#{file_path}.#{file_type}")
      File.expand_path(relative_path)
    end

    def perform_file_operation(activity_descriptor, full_path, logger)
      begin
        yield if block_given?
      rescue Errno::EACCES, Errno::EPERM => e
        error_message = "Permission error during file #{activity_descriptor} operation: #{e.message}"
        logger.log_error(error_message)
        return
      rescue StandardError => e
        error_message = "Error during file operation: #{e.message}"
        logger.log_error(error_message)
        return
      end

      activity_details = {
        'full_path_to_file' => full_path,
        'activity_descriptor' => activity_descriptor,
      }

      logger.log_activity("file_#{activity_descriptor}", activity_details)
    end
end
