module TaskWarrior
  class Facade
    def initialize(config_file)
      @config_file = config_file
    end
    
    def tasks
      JSON.parse(%x[task rc:#{@config_file} export.json]).each_with_object([]){|result, t|
        result << TaskMapper.map(t)
      }
      result
    end
  end
end