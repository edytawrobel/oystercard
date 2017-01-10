require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { instance_double(Station) }
  let(:exit_station) { instance_double(Station) }

  before :each do
    @max_balance = described_class::MAX_BALANCE
    @min_charge = described_class::MIN_CHARGE
  end

  describe 'initialization' do
    it 'is created with a balance of zero by default' do
      expect(oystercard.balance).to eq(0)
    end
  end

  describe 'journey history' do
    it { is_expected.to respond_to(:journey_recorder) }

    it 'expect journey directory to be empty' do
      expect(oystercard.journey_recorder).to be_empty
    end

    it 'touching in and out creates one journey' do
      oystercard.top_up(20)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journey_recorder).not_to be_empty
      expect(oystercard.journey_recorder[0].class).to eq(Hash)
    end
  end

  context '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect{ oystercard.top_up 10 }.to change{ oystercard.balance }.by 10
    end

    it 'can be topped up with a specific amount' do
      allow(oystercard).to receive(:balance) {20}
      #oystercard.top_up(20)
      expect(oystercard.balance).to eq(20)
    end
  end

  it 'raises an error when the balance exceeds the max limit' do
    message = "You have exceeded #{@max_balance}!"
    expect { oystercard.top_up(91) }.to raise_error message
    expect(oystercard.balance).to eq (0)
  end

  describe '#touch_in' do
    it {is_expected.to respond_to(:touch_in)}

    it 'raises an error when the balance is lower than the minimum fare' do
      message = 'Not sufficient balance to continue journey'
      expect{ oystercard.touch_in(entry_station) }.to raise_error message
    end

    it 'expects the card to remember the entry station' do
      oystercard.top_up(@min_charge)
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq entry_station
    end
  end

  describe '#entry_station' do
    it { is_expected.to respond_to(:entry_station) }
  end

  describe '#touch_out' do
    it {is_expected.to respond_to(:touch_out)}

    it 'deducts the balance by minimum fare' do
      expect { oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-@min_charge)
    end

    it 'after touch out sets the entry station to nil' do
      oystercard.touch_out(exit_station)
      expect(oystercard.entry_station).to eq(nil)
    end

  end

  describe '#in_journey?' do
    it {is_expected.to respond_to(:in_journey?)}

    it 'checks if the card is in use' do
      oystercard.top_up(@min_charge)
      expect(oystercard.touch_in(entry_station)).to eq true
    end

    it 'checks if the card is not in use' do
      oystercard.top_up(@min_charge)
      oystercard.touch_in(entry_station)
      expect(oystercard.touch_out(exit_station)).to eq false
    end
  end
end
