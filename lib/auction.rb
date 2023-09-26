class Auction

  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(item)
    @items << item
  end

  def item_names
    @items.map { |item| item.name }
  end

  def unpopular_items
    @items.find_all { |item| item.bids == {} }
  end

  def potential_revenue
    @items.map do |item| 
      if item.bids == {}
        0
      else
        item.current_high_bid
      end
    end.sum
  end

  def bidders
    bidders_as_objects.map { |bidder| bidder.name }
  end

  def bidders_as_objects
    @items.flat_map { |item| item.bids.keys }.uniq
  end

  def bidder_info
    bidders_hash = {}
    bidders_as_objects.each do |bidder|
      bidders_hash[bidder] = individual_bidder_info(bidder)
    end
    bidders_hash
  end

  def individual_bidder_info(bidder)
    attendee_hash = {}
    attendee_hash[:budget] = bidder.budget
    attendee_hash[:items] = bidder.items
    attendee_hash
  end
end
