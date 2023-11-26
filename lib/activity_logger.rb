require 'fileutils'
require 'json'

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
      'activity_type' => activity_type
    }

    log_entry.merge!(activity_details)
    File.open(@log_file, 'a') { |f| f.puts(log_entry.to_json) }
  end

  def log_error(error_message)
    error_entry = {
      'username' => ENV['USER'],
      'timestamp' => Time.now.utc,
      'error_message' => error_message
    }

    File.open(@log_file, 'a') { |f| f.puts(error_entry.to_json) }
  end

  private

  def build_log_file
    timestamp = Time.now.utc.strftime('%Y%m%d_%H%M%S')
    File.join(@output_dir, "activity_log_#{timestamp}.json")
  end
end
