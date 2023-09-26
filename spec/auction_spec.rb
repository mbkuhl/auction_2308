require './spec/spec_helper'

RSpec.describe Auction do
  before(:each) do
    @auction = Auction.new
    @attendee1 = Attendee.new({name: 'Megan', budget: '$50'})
    @attendee2 = Attendee.new({name: 'Bob', budget: '$75'})
    @attendee3 = Attendee.new({name: 'Mike', budget: '$100'})
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
    @item3 = Item.new('Homemade Chocolate Chip Cookies')
    @item4 = Item.new('2 Days Dogsitting')
    @item5 = Item.new('Forever Stamps')
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@auction).to be_a(Auction)
      expect(@auction.items).to eq([])
    end
  end

  describe '#add_item' do
    it 'can add items' do
      @auction.add_item(@item1)
      expect(@auction.items).to eq([@item1])
      @auction.add_item(@item2)
      expect(@auction.items).to eq([@item1, @item2])
    end
  end
  
  describe '#item_names' do
    it 'can add items' do
      expect(@auction.item_names).to eq([])
      @auction.add_item(@item1)
      expect(@auction.item_names).to eq(["Chalkware Piggy Bank"])
      @auction.add_item(@item2)
      expect(@auction.item_names).to eq(["Chalkware Piggy Bank", "Bamboo Picture Frame"])
    end
  end

  describe '#unpopular_items' do
    it 'gives a list of items with no bids' do
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      @item4.add_bid(@attendee3, 50)
      expect(@auction.unpopular_items).to eq([@item2, @item3, @item5])
      @item3.add_bid(@attendee2, 15)
      expect(@auction.unpopular_items).to eq([@item2, @item5])
    end
  end

  describe '#potential_revenue' do
    it 'gives a sum of all the highest bids' do
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
      expect(@auction.potential_revenue).to eq(0)
      @item1.add_bid(@attendee2, 20)
      expect(@auction.potential_revenue).to eq(20)
      @item1.add_bid(@attendee1, 22)
      expect(@auction.potential_revenue).to eq(22)
      @item4.add_bid(@attendee3, 50)
      expect(@auction.potential_revenue).to eq(72)
      @item3.add_bid(@attendee2, 15)
      expect(@auction.potential_revenue).to eq(87)
    end
  end

  describe '#bidders' do
    it 'can return a list of all bidders who have place a bid on an item' do
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
      expect(@auction.bidders).to eq([])
      @item1.add_bid(@attendee2, 20)
      expect(@auction.bidders).to eq([@attendee2.name])
      @item1.add_bid(@attendee1, 22)
      expect(@auction.bidders.sort).to eq([@attendee2.name, @attendee1.name].sort)
      @item4.add_bid(@attendee3, 50)
      expect(@auction.bidders.sort).to eq([@attendee2.name, @attendee1.name, @attendee3.name].sort)
      @item3.add_bid(@attendee2, 15)
      expect(@auction.bidders.sort).to eq([@attendee2.name, @attendee1.name, @attendee3.name].sort)
    end
  end

  describe '#bidder_info' do
    it 'can return an hash of attendee information, displayed as a hash' do
      @auction.add_item(@item1)
      @auction.add_item(@item2)
      @auction.add_item(@item3)
      @auction.add_item(@item4)
      @auction.add_item(@item5)
      expect(@auction.bidder_info).to eq({})
      @item1.add_bid(@attendee2, 20)
      expect(@auction.bidder_info).to eq({
        @attendee2 => {
          budget: 75,
          items: [@item1]
        }
      })
      @item1.add_bid(@attendee1, 22)
      expect(@auction.bidder_info).to eq({
        @attendee2 => {
          budget: 75,
          items: [@item1]
        },
        @attendee1 => {
          budget: 50,
          items: [@item1]
        },
        })
        @item4.add_bid(@attendee3, 50)
      expect(@auction.bidder_info).to eq({
        @attendee2 => {
          budget: 75,
          items: [@item1]
        },
        @attendee1 => {
          budget: 50,
          items: [@item1]
        },
        @attendee3 => {
          budget: 100,
          items: [@item4]
        },
      })
      @item3.add_bid(@attendee2, 15)
      expect(@auction.bidder_info).to eq({
        @attendee2 => {
          budget: 75,
          items: [@item1, @item3]
        },
        @attendee1 => {
          budget: 50,
          items: [@item1]
        },
        @attendee3 => {
          budget: 100,
          items: [@item4]
        },
      })
    end
  end

  describe '#date' do
    it 'can return the date in which the object was created' do
      expect(@auction.date).to be_a(String)
      allow(Date).to receive(:today).and_return(Date.new(2000, 1, 1))
      auction = Auction.new
      expect(auction.date).to be_a(String)
      expect(auction.date).to eq('01/01/2000')
    end
  end

  # describe '#close_auction' do
  #   it 'can close the auction and sell all items as bid on, if possible' do
  #     @auction.add_item(@item1)
  #     @auction.add_item(@item2)
  #     @auction.add_item(@item3)
  #     @auction.add_item(@item4)
  #     @auction.add_item(@item5)
  #     @item1.add_bid(@attendee2, 20)
  #     @item1.add_bid(@attendee1, 22)
  #     @item4.add_bid(@attendee3, 70)
  #     @item3.add_bid(@attendee2, 15)
  #     @item3.add_bid(@attendee3, 50)
  #     expect(@auction.close_auction).to eq({
  #       @item1 => @attendee1,
  #       @item2 => 'Not Sold',
  #       @item3 => @attendee2,
  #       @item4 => @attendee3,
  #       @item5 => 'Not Sold'
  #     })
  #   end
  # end

end