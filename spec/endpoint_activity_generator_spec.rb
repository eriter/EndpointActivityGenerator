require_relative '../endpoint_activity_generator.rb'
require 'rspec'

describe EndpointActivityGenerator do
  before(:each) do
    @activity_generator = EndpointActivityGenerator.new
  end

  after(:each) do
    FileUtils.rm_rf(@activity_generator.instance_variable_get(:@output_dir))
  end

  describe '#start_process' do
    it 'creates a log file' do
      @activity_generator.start_process('/bin/ls', ['-l'])
      log_file_path = File.join(@activity_generator.instance_variable_get(:@output_dir), 'activity_log.yml')
      expect(File.exist?(log_file_path)).to be true
    end
  end

  describe '#create_file' do
    it 'creates a file and logs the activity' do
      @activity_generator.create_file('test_file')
      file_path = File.join(@activity_generator.instance_variable_get(:@output_dir), 'test_file.txt')
      expect(File.exist?(file_path)).to be true
      log_file_path = File.join(@activity_generator.instance_variable_get(:@output_dir), 'activity_log.yml')
      expect(File.exist?(log_file_path)).to be true
    end
  end
end
