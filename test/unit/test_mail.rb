# frozen_string_literal: true

require 'test_helper'
require 'mail'

class TestMail < Test::Unit::TestCase
  def test_signature
    m = Mail.new(File.read(fixture('mail_with_signature.txt')))
    assert(m)
    assert(m.body.include?('-- '))
    assert_false(m.body.decoded.split('-- ').include?('-- '))
  end

  def fixture(name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', name)
  end
end
