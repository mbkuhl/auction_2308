class Auction

  attr_reader :items, :date

  def initialize
    @items = []
    @date = Date.today.strftime("%d/%m/%Y")
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

  def close_auction
    close_hash = {}

    items_sorted_by_highest_bid.each do |item|
      close_hash[item] = sell_item(item)
    end
    close_hash
  end

  def sell_item(item)
    return "Not Sold" if item.current_high_bid_with_attendee.nil? # || item.current_high_bid_with_attendee == []
    best_bidder_budget = item.current_high_bid_with_attendee[0].budget
    best_bid = item.current_high_bid
    until best_bidder_budget > best_bid || best_bid == 0
      item.remove_highest_bid
      best_bidder_budget = item.current_high_bid_with_attendee[0].budget
      best_bid = item.current_high_bid
    end
    if item.current_high_bid == 0
      "Not Sold"
    else
      sold_to = item.current_high_bid_with_attendee[0]
      item.current_high_bid_with_attendee[0].budget -= item.current_high_bid
      sold_to
    end
  end

  def items_sorted_by_highest_bid
    @items.sort_by do |item| 
      item.current_high_bid
    end.reverse
  end
end
