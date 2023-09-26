require './spec/spec_helper'

RSpec.describe Item do
  before(:each) do
    @item1 = Item.new('Chalkware Piggy Bank')
    @item2 = Item.new('Bamboo Picture Frame')
    @attendee1 = Attendee.new({name: 'Megan', budget: '$50'})
    @attendee2 = Attendee.new({name: 'Bob', budget: '$75'})
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@item1).to be_a(Item)
      expect(@item2).to be_a(Item)
      expect(@item1.name).to eq("Chalkware Piggy Bank")
      expect(@item1.bids).to eq({})
    end
  end

  describe '#add_bid' do
    it 'can have a bid placed on it' do
      @item1.add_bid(@attendee2, 20)
      expect(@item1.bids).to eq({
        @attendee2 => 20
      })
      @item1.add_bid(@attendee1, 22)
      expect(@item1.bids).to eq({
        @attendee2 => 20,
        @attendee1 => 22
      })
    end
  end

  describe '#current_high_bid' do
    it 'can give the current highest bid' do
      @item1.add_bid(@attendee2, 20)
      @item1.add_bid(@attendee1, 22)
      expect(@item1.current_high_bid).to eq(22)
    end
  end

  describe '#close_bidding' do

  end
end