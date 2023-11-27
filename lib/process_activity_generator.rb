class ProcessActivityGenerator

  def start_process(executable_path, arguments = [], logger)
    begin
      process_id = spawn_process(executable_path, arguments)
      log_process_start(executable_path, arguments, process_id, logger)
    rescue => e
      logger.log_error("Error starting process: #{e.message}")
    end
  end

  private

  def spawn_process(executable_path, arguments)
    spawn(executable_path, *arguments)
  end

  def log_process_start(executable_path, arguments, process_id, logger)
    activity_details = {
        'process_name' => File.basename(executable_path),
        'process_command_line' => [executable_path, *arguments].join(' '),
        'process_id' => process_id
      }

      logger.log_activity('process_start', activity_details)
    end

end
