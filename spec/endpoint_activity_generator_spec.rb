require_relative '../endpoint_activity_generator.rb'
require_relative '../process_activity_generator.rb'
require_relative '../activity_logger.rb'
require 'rspec'
require 'tmpdir'

describe EndpointActivityGenerator do
  let(:temp_dir) { Dir.mktmpdir }

  before(:each) do
    @activity_generator = EndpointActivityGenerator.new
    @logger = ActivityLogger.new(temp_dir)
    @activity_generator.instance_variable_set(:@output_dir, temp_dir)
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

  describe '#create_file' do
    it 'creates a file and logs the activity' do
      @activity_generator.create_file('test_file', @logger)
      file_path = File.join(temp_dir, 'test_file.txt')
      expect(File.exist?(file_path)).to be true
      log_file_path = File.join(temp_dir, 'activity_log.json')
      expect(File.exist?(log_file_path)).to be true
    end
  end

  describe '#modify_file' do
    it 'modifies a file and logs the activity' do
      file_path = 'test_file'

      @activity_generator.modify_file(file_path, 'txt', 'additional content', @logger)

      full_path = File.join(temp_dir, "#{file_path}.txt")
      expect(File.exist?(full_path)).to be true
      log_file_path = File.join(temp_dir, 'activity_log.json')
      expect(File.exist?(log_file_path)).to be true

      # logging is not ordinarily something we'd test, but the log outputs of activity generation
      # are a key functionality. If we chose to test log contents, we could do something like this:

      log_entry = JSON.load_file(log_file_path, permitted_classes: [Time])
      expect(log_entry['activity_type']).to eq('file_modify')
      expect(log_entry['full_path_to_file']).to eq(File.expand_path(full_path))
      expect(log_entry['activity_descriptor']).to eq('modify')
      expect(log_entry['process_name']).to eq($PROGRAM_NAME)
    end
  end
end
