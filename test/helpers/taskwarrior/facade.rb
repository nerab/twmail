require 'json'

module TaskWarrior
  class Facade
    def initialize(config_file)
      @config_file = config_file
    end
    
    def tasks
      JSON.parse(export).each_with_object([]){|result, t|
        result << TaskMapper.map(t)
      }
    end
    
    private
    def exec(cmd)
      %x[task rc.verbose=nothing rc:#{@config_file} #{cmd}]
    end
    
    def export
      exec('export').tap{|result|
        result << '{}' if result.empty?
      }
    end
  end
end