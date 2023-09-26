class Item 
  attr_reader :name, :bids
  def initialize(name)
    @name = name
    @bids = {}
  end


  def add_bid(attendee, bid)
    attendee.items << self
    @bids[attendee] = bid
  end

  def current_high_bid
    @bids.values.sort { |bid| bid }.first
  end

  
end