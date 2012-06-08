module TaskWarrior
  class TaskMapper
    class << self
      def map(json)
        Task.new(json['description']).tap{|t|
          t.id = json['id'].to_i
          t.uuid = json['uuid']
          t.entry = DateTime.parse(json['entry'])
          t.status = json['status'].to_sym
        }
      end
    end
  end
end