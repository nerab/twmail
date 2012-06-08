module TaskWarrior
  class TaskMapper
    class << self
      def map(json)
        t = Task.new
        t.description = json.description
        t
      end
    end
  end
end