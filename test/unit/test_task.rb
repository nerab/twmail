require 'test_helper'

class TestTask < TaskWarriorMailTest::TestCase
  def setup
    @task = TaskWarrior::Task.new('foobar')
    @task.id = 1
    @task.uuid = '66465716-b08d-41ea-8567-91b988a2bcbf'
    @task.entry = DateTime.now
    @task.status = :pending    
  end
  
  def test_task_id_nil
    @task.id = nil
    assert_invalid(@task)
  end
  
  def test_task_id_0
    @task.id = 0
    assert_invalid(@task)
  end
  
  def test_task_uuid_nil
    @task.uuid = nil
    assert_invalid(@task)
  end
  
  def test_task_uuid_empty
    @task.uuid = ''
    assert_invalid(@task)
  end
  
  def test_task_uuid_wrong_format
    @task.uuid = 'abcdefg'
    assert_invalid(@task)
  end
  
  def test_task_valid
    assert(@task.valid?, error_message(@task.errors))
  end

  private
  def assert_invalid(task)
    assert(task.invalid?, 'Expect validation to fail')
  end
  
  def error_message(errors)
    errors.each_with_object([]){|e, result| 
      result << e.join(' ')
    }.join("\n")
  end
end
