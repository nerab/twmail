require 'active_model'

module TaskWarrior
  class Task
    attr_accessor :description, :id, :entry, :status, :uuid
    
    include ActiveModel::Validations
    validates :description, :id, :entry, :status, :uuid, :presence => true
    validates :id, :numericality => { :only_integer => true, :greater_than => 0}
    validates :uuid, :format => {:with => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/,
                                 :message => "'%{value}' does not match the expected format of a UUID"}
    validates :status, :inclusion => {:in => [:pending, :waiting, :complete], :message => "%{value} is not a valid status"}
    
    def initialize(description)
      @description = description
    end
  end
end