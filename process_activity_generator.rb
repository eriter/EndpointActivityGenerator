class ProcessActivityGenerator

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

end
