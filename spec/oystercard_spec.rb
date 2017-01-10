require 'oystercard'

describe Oystercard do

  subject(:oystercard) { described_class.new }

  describe 'initialization' do
    it 'is created with a balance of zero by default' do
      expect(oystercard.balance).to eq(0)
    end

    it 'is not in use' do
      expect(oystercard.in_journey).to eq false
    end
  end

  context '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect{ oystercard.top_up 10 }.to change{ oystercard.balance }.by 10
    end

    it 'can be topped up with a specific amount' do
      subject.top_up(20)
      expect(oystercard.balance).to eq(20)
    end
  end

  it 'raises an error when the balance exceeds the max limit' do
    max_balance = described_class::MAX_BALANCE
    message = "You have exceeded #{max_balance}!"
    expect { oystercard.top_up(91) }.to raise_error message
    expect(oystercard.balance).to eq (0)
  end

  describe '#deduct' do
    it { is_expected.to respond_to(:deduct).with(1).argument }

    it 'deducts the balance by specific amount' do
        oystercard.top_up(20)
        expect{ oystercard.deduct(5) }.to change{ oystercard.balance}.by -5
    end
  end

  describe '#touch_in' do
    it {is_expected.to respond_to(:touch_in)}

    it 'raises an error when the balance is lower than the minimum fare' do
      message = 'Not sufficient balance to continue journey'
      expect{ oystercard.touch_in }.to raise_error message
    end

  end

  describe '#touch_out' do
    it {is_expected.to respond_to(:touch_out)}
  end

  describe '#in_journey' do
    it {is_expected.to respond_to(:in_journey)}

    it 'checks if the card is in use' do
      min_balance = described_class::MIN_BALANCE
      oystercard.top_up(min_balance)
      expect(oystercard.touch_in).to be true
    end

    it 'checks if the card is not in use' do
      min_balance = described_class::MIN_BALANCE
      oystercard.top_up(min_balance)
      oystercard.touch_in
      expect(oystercard.touch_out).to eq false
    end

  end

end
