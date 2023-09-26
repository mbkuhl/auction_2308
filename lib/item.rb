class Item 
  attr_reader :name, :bids
  def initialize(name)
    @name = name
    @bids = {}
  end

  def bidding_closed?
    return false if @bidding_closed.nil?
    @bidding_closed
  end

  def add_bid(attendee, bid)
    return if bidding_closed?
    attendee.items << self
    @bids[attendee] = bid
  end

  def current_high_bid
    @bids.values.sort { |bid| bid }.first
  end

  def close_bidding
    @bidding_closed = true
    "Bids are now closed"
  end
end