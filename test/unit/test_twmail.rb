require 'test_helper'

class TestHelpers < TaskWarrior::Test::Integration::TestCase
  def test_regular
    result = deliver_fixture(0, fixture('mail_regular.txt'))
    assert_empty(result)
    assert_equal(1, task('count').to_i)

    tasks = export_tasks
    assert_equal(1, tasks.size)
    assert_equal('Send some test mails', tasks.first['description'])

    assert_equal(1, tasks.first['annotations'].size)
    assert(tasks.first['annotations'].first.to_s =~ /Nigeria/)
  end

  def test_multipart
    result = deliver_fixture(0, fixture('mail_multipart.txt'))
    assert_empty(result)
    assert_equal(1, task('count').to_i)

    tasks = export_tasks
    assert_equal(1, tasks.size)
    assert_equal('MenTaLguY: Atomic Operations in Ruby', tasks.first['description'])

    assert_equal(1, tasks.first['annotations'].size)
    assert(tasks.first['annotations'].first.to_s =~ /atomic/)
  end

 def test_separator
  result = deliver_fixture(0, fixture('mail_separator.txt'))
  assert_empty(result)
  assert_equal(1, task('count').to_i)

  tasks = export_tasks
  assert_equal(1, tasks.size)
  task = tasks.first
  assert_equal('Try IFTTT / PinReadable', task['description'])
  assert_true(task['tags'].include?('kindle'))
 end

#  def test_missing_fixture
#    result = deliver_fixture(1, 'missing fixture')
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
end
