require 'oystercard'

describe Oystercard do

  describe 'initialization' do
    it 'has a balance of zero when first created' do
      expect(Oystercard.new.balance).to eq(0)
    end
  end
end
