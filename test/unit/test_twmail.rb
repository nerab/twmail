require 'test_helper'
require 'tempfile'
require 'tmpdir'
require 'erb'
require 'json'

class TestHelpers < Test::Unit::TestCase
  def setup
    @data_dir = Dir.mktmpdir
    @taskrc_file = build_taskrc(:data_dir => @data_dir)
  end
  
  def teardown
    FileUtils.rm_r(@data_dir)
    File.delete(@taskrc_file)
  end

  def test_empty
    # http://taskwarrior.org/issues/1017
    # assert_empty(export_tasks)
    
    # Use a placeholder as workaround
    exec("add placeholder")
    assert_equal(1, export_tasks.size)
  end
  
  def test_import
    contents = {:description => "foobar"}
    input_file = Tempfile.new('test_simple')
    
    begin
      input_file.write(contents.to_json)
      input_file.close
      
      # TODO Replace temp file with in-process version
#      exec("import <(echo '#{contents.to_json}')")
      exec("import #{input_file.path}")
      
      tasks = export_tasks
      assert_equal(1, tasks.size)
      assert_equal('foobar', tasks.first['description'])
    ensure
      input_file.unlink
    end
  end

  def test_regular
    result = deliver_fixture(0, fixture('mail_regular.txt'))
    assert_empty(result)
    assert_equal(1, exec('count').to_i)
    
    tasks = export_tasks
    assert_equal(1, tasks.size)
    assert_equal('Send some test mails', tasks.first['description'])
    
    assert_equal(1, tasks.first['annotations'].size)
    assert(tasks.first['annotations'].first.to_s =~ /Nigeria/)
  end

  def test_multipart
    result = deliver_fixture(0, fixture('mail_multipart.txt'))
    assert_empty(result)
    assert_equal(1, exec('count').to_i)
    
    tasks = export_tasks
    assert_equal(1, tasks.size)
    assert_equal('MenTaLguY: Atomic Operations in Ruby', tasks.first['description'])
    
    assert_equal(1, tasks.first['annotations'].size)
    assert(tasks.first['annotations'].first.to_s =~ /atomic/)
  end

#  def test_missing_fixture
#    result = assert_fixture(1, 'missing fixture')
#    assert_empty(result)
#  end
  
  protected
  def deliver_fixture(status, fixture)
    twmail = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'twmail')
    ENV['TASKRC'] = @taskrc_file
    output = %x[cat #{fixture} | #{twmail}]
    assert_equal(status, $?.exitstatus)
    output
  end
  
  def fixture(name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', name)
  end
  
  def export_tasks
    JSON[exec('export')]
  end
  
  def exec(cmd)
    ENV['TASKRC'] = @taskrc_file
    %x[task #{cmd}]
  end
  
  def build_taskrc(options = {})
    taskrc_file = Tempfile.new('taskrc')
    data_dir = options[:data_dir]
    
    begin
      taskrc_file.write(ERB.new(File.read(File.join(File.dirname(__FILE__), '..', 'templates', 'taskrc.erb')), 0, "%<>").result(binding))
      return taskrc_file.path
    ensure
      taskrc_file.close
    end
  end
end
