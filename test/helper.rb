require 'bundler'
Bundler.require

require 'test/unit'

module TaskWarriorMailTest
  class TestCase < Test::Unit::TestCase
#    FIXTURES_DIR = File.join(File.dirname(__FILE__), 'fixtures')
#
#    def fixture(name = self.class.name.underscore.match(/test_(.*)/)[1])
#      file_name = nil
#      
#      %w{.yaml .yml .json}.each{|ext| 
#        file_name = File.join(FIXTURES_DIR, "#{name}#{ext}")
#        break if File.exist?(file_name)
#      }
#
#      raw = File.read(file_name)
#
#      case File.extname(file_name)
#      when '.yaml'
#        YAML.load(raw)
#      when '.json'
#        JSON.parse(raw, :symbolize_names => true)
#      else
#        raw
#      end
#    end
  end
end