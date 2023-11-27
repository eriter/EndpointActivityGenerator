require 'fileutils'
require 'yaml'

class ActivityLogger
  def initialize(output_directory = 'generated_activity')
    @output_dir = output_directory
    @log_file = build_log_file
    # Ensure output directory exists
    FileUtils.mkdir_p(@output_dir)
  end

  def log_activity(activity_type, activity_details)
    # Build log entry with a set of sensible defaults
    # Overwrite default log values as appropriate when calling
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

  # Construct a unique log file on logger initialization
  # Intent: each activity generation run generates its own log file
  def build_log_file
    log_timestamp = Time.now.utc.strftime('%Y%m%d_%H%M%S')
    File.join(@output_dir, "activity_log_#{log_timestamp}.yml")
  end

  # Gather information for identifying parent process
  def default_process_id
    process_id = Process.pid
  end

  # Note that this default is for attributing a name to actions performed by this program
  # If you create or call other processes to generate activity, please overwrite
  def default_process_name
    File.expand_path($PROGRAM_NAME)
  end

  # Shelling out to ps is platform dependent, alas
  def default_process_command_line
    process_command_line = `ps -p #{default_process_id} -o command=`
    process_command_line.strip
  end
end
