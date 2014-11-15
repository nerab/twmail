require 'open3'
require 'test/unit'

class Command
  def exec(cmd = '', args = {})
    env.each{|k,v| ENV[k.to_s] = v.to_s}
    line = build_line(cmd, args)
    Open3.capture3(line)
  end

  def env
    {}
  end

  def default_args
    {}
  end

  def executable
    raise 'Subclasses must override this method'
  end

  private

  def build_line(cmd = '', args = {})
    [].tap{|line|
      line << executable
      line << default_args.merge(args).map{|k,v| "#{Shellwords.escape(k.strip)}=#{Shellwords.escape(v.strip)}"}.join(' ')
      line << cmd.strip
      line.reject!{|part| part.empty?}
    }.join(' ')
  end

  def overrides(env)
    intersection = env.keys.to_set & ENV.keys.to_set
    ENV.select{|k,v| intersection.include?(k)}
  end
end

class TaskWarriorCommand < Command
  attr_accessor :data_dir

  def version
    exec('_version')
  end

  def count
    exec('count')
  end

  def env
    raise "data_dir must not be empty for '#{executable}'" if @data_dir.nil? || data_dir.empty?
    {TASKDATA: @data_dir}
  end

  def default_args
    {'rc.verbose' => 'off', 'rc.json.array' => 'on'}
  end

  def executable
    'task'
  end
end

class TaskUUID < TaskWarriorCommand
  def create(description)
    exec(description)
  end

  def executable
    # The gem version that uses the binstub fails if the script is not Ruby
    #'task-uuid'

    # The local version, called directly, works fine even if it's a Bash script
    File.join(File.dirname(__FILE__), '..', '..', 'bin', 'task-uuid')
  end

  def default_args
    {}
  end
end

class TestTaskUUID < Test::Unit::TestCase#Minitest::Test
  def setup
    @tw = TaskWarriorCommand.new
    @tw.data_dir = Dir.mktmpdir(name)

    raise "TASKRC must not be set, but it is #{ENV['TASKRC']}" if ENV['TASKRC']

  end

  def teardown
    FileUtils.rm_rf(@tw.data_dir)
  end

  def test_version
    out, err, status = @tw.version
    assert(status.success?)
    assert_empty(err)
    assert_not_empty(out)
    assert_equal('2.3.0', out.chomp)
  end

  def test_empty
    out, err, status = @tw.count
    assert(status.success?)
    assert_empty(err)
    assert_not_empty(out)
    assert_equal('0', out.chomp)
  end

  def test_task_uuid
    task_uuid = TaskUUID.new
    task_uuid.data_dir = Dir.mktmpdir(name)
    out, err, status = task_uuid.create('foo bar')
    assert_empty(err)
    assert_not_empty(out)
    assert_match(/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/, out.chomp)
  end
end
