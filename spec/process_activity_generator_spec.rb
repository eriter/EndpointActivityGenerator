require_relative '../lib/activity_logger.rb'
require_relative '../lib/process_activity_generator.rb'
require 'rspec'
require 'tmpdir'

describe ProcessActivityGenerator do
  let(:temp_dir) { Dir.mktmpdir }

  before(:each) do
    @logger = ActivityLogger.new(temp_dir)
    @logger.instance_variable_set(:@log_file, "#{temp_dir}/activity_log.json")
  end

  after(:each) do
    FileUtils.rm_rf(temp_dir)
  end

  describe '#start_process' do
    before(:each) do
      @process_activity = ProcessActivityGenerator.new
      @process_activity.instance_variable_set(:@output_dir, temp_dir)
    end

    it 'creates a log file' do
      @process_activity.start_process('/bin/ls', ['-l'], @logger)
      log_file_path = File.join(temp_dir, 'activity_log.json')
      expect(File.exist?(log_file_path)).to be true
    end
  end
end
