require 'json'

module TaskWarrior
  class Repository
    def initialize(config_file = nil)
      @config_file = config_file
    end
    
    def <<(task)
      exec("add #{task.description}")
    end
    
    def tasks
      # Wrap the export response in brackets, see http://taskwarrior.org/issues/1014
      JSON.parse("[#{exec('export')}]").each_with_object([]){|t, result|
        result << TaskMapper.map(t)
      }
    end
    
    private
    def exec(cmd)
      config = @config_file ? "rc:#{@config_file} " : ""
      %x[task rc.verbose=nothing #{config}#{cmd}]
    end
  end
end