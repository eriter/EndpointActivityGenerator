require 'fileutils'
require 'json'

class ActivityLogger
  def initialize(output_directory = 'generated_activity')
    @output_dir = output_directory
    FileUtils.mkdir_p(@output_dir)
  end

  def log_activity(activity_type, details)
    log_entry = {
      'username' => ENV['USER'],
      'timestamp' => Time.now.utc,
      'activity_type' => activity_type
    }

    log_file = File.join(@output_dir, 'activity_log.json')
    log_entry.merge!(details)
    File.open(log_file, 'a') { |f| f.puts(log_entry.to_json) }
  end
end
