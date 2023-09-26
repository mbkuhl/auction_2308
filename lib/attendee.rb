class Attendee
  attr_reader :name
  attr_accessor :items, :budget
  def initialize(attendee_hash)
    @name = attendee_hash[:name]
    @budget = attendee_hash[:budget].gsub("$", "").to_i
    @items = []
  end
end