class Attendee
  attr_reader :name, :budget
  attr_accessor :items
  def initialize(attendee_hash)
    @name = attendee_hash[:name]
    @budget = attendee_hash[:budget].gsub("$", "").to_i
    @items = []
  end
end