require File.join(File.dirname(__FILE__), '..', 'helper')

require 'tmpdir'

require 'taskwarrior/facade'
require 'taskwarrior/task'
require 'taskwarrior/task_mapper'

class TestFacade < TaskWarriorMailTest::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
    @taskrc_file = File.join(@tmp_dir, '.taskrc')
    
    # write our tmp path to the taskrc file
    File.open(@taskrc_file, 'w'){|f| 
      f.write("data.location=#{@tmp_dir}")
    }    
    
    @tw = TaskWarrior::Facade.new(@taskrc_file)
  end
  
  def teardown
    FileUtils.rm_rf(@tmp_dir)
  end
  
  def test_tasks_empty
    tasks = @tw.tasks
    assert_not_nil(tasks)
    assert_equal(0, tasks.size)
  end
  
  def test_tasks_single
    desc = 'Fetch water'
    t = TaskWarrior::Task.new(desc)
    @tw << t
    
    tasks = @tw.tasks
    assert_not_nil(tasks)
    assert_equal(1, tasks.size)
    
    first_task = tasks.first
    assert_not_nil(first_task)
    assert_equal(desc, first_task.description)
    assert(first_task.valid?)
    assert_in_delta(DateTime.now, first_task.entry, 0.01)
    assert_equal(:pending, first_task.status)
  end
end
