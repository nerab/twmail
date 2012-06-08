require 'json'

module TaskWarrior
  class Facade
    def initialize(config_file)
      @config_file = config_file
    end
    
    def <<(task)
      exec("add #{task.description}")
    end
    
    def tasks
      JSON.parse("[#{(exec('export'))}]").each_with_object([]){|t, result|
        result << TaskMapper.map(t)
      }
    end
    
    private
    def exec(cmd)
      %x[task rc.verbose=nothing rc:#{@config_file} #{cmd}]
    end
  end
end