require 'oystercard'

describe Oystercard do

  describe 'initialization' do
    it 'is created with a balance of zero by default' do
      oystercard = Oystercard.new(0)
      expect(oystercard.balance).to eq(0)
    end
  end

  context '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can be topped up with a specific amount' do
      oystercard = Oystercard.new(0)
      oystercard.top_up(20)
      expect(oystercard.balance).to eq(20)
    end

    it 'raises an error when the balance exceeds the max limit' do
      oystercard = Oystercard.new(0)
      message = "Max balance is 90"
      expect { oystercard.top_up(91) }.to raise_error message
    end

    it 'raises an error when the balance exceeds the max limit' do
      oystercard = Oystercard.new(0)
      message = "Max balance is 90"
      expect { oystercard.top_up(91) }.to raise_error message
      expect(oystercard.balance).to eq (0)
    end

  end

end
