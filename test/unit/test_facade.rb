require File.join(File.dirname(__FILE__), '..', 'helper')

require 'tmpdir'

require 'taskwarrior/facade'
require 'taskwarrior/task'
require 'taskwarrior/task_mapper'


# Beware: Pseudo-code still ...

# setup: keep the test data separate
#export TASKDATA=tmp/.task 

# run twmail with fixture data
#twmail < test/fixtures/sample.txt

# read back by exporting the just added task
#task export LATEST

# assert that we actually imported
#assert_equal "Tweet from @vowe", 

# teardown: undo changes
#task rc.confirmation:no undo

class TestFacade < TaskWarriorMailTest::TestCase
  def setup
    @tmp_dir = Dir.mktmpdir
    #puts "all work done in #{@tmp_dir}"    
    
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
end
