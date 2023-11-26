require 'fileutils'
require 'yaml'

class ActivityLogger
  def initialize(output_directory = 'generated_activity')
    @output_dir = output_directory
    @log_file = build_log_file
    FileUtils.mkdir_p(@output_dir)
  end

  def log_activity(activity_type, activity_details)
    log_entry = {
      'username' => ENV['USER'],
      'timestamp' => Time.now.utc,
      'activity_type' => activity_type,
      'process_command_line' => default_process_command_line,
      'process_id' => default_process_id,
      'process_name' => default_process_name
    }

    log_entry.merge!(activity_details)
    File.open(@log_file, 'a') { |f| f.puts(log_entry.to_yaml) }
  end

  def log_error(error_message)
    error_entry = {
      'username' => ENV['USER'],
      'timestamp' => Time.now.utc,
      'error_message' => error_message
    }

    File.open(@log_file, 'a') { |f| f.puts(error_entry.to_yaml) }
  end

  private

  def build_log_file
    log_timestamp = Time.now.utc.strftime('%Y%m%d_%H%M%S')
    File.join(@output_dir, "activity_log_#{log_timestamp}.yml")
  end

  def default_process_id
    process_id = Process.pid
  end

  def default_process_name
    File.expand_path($PROGRAM_NAME)
  end

  #shelling out to ps is platform dependent, alas
  def default_process_command_line
    process_command_line = `ps -p #{default_process_id} -o command=`
    process_command_line.strip
  end
end
