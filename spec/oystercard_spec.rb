require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { instance_double(Station) }
  let(:exit_station) { instance_double(Station) }
  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }


  before :each do
    @max_balance = described_class::MAX_BALANCE
    @min_charge = described_class::MIN_CHARGE
  end

  it "responds to ::MIN_CHARGE" do
    expect(described_class).to be_const_defined(:MIN_CHARGE)
  end

  it "responds to ::MAX_BALANCE" do
    expect(described_class).to be_const_defined(:MAX_BALANCE)
  end

  describe 'initialization' do
    it 'is created with a balance of zero by default' do
      expect(oystercard.balance).to eq(0)
    end

    it { is_expected.not_to be_in_journey }

    it 'has an empty journey recorder array' do
     expect(oystercard.journey_recorder).to be_empty
    end
  end

  context 'journey history' do
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

    it 'raises an error when the balance exceeds the max limit' do
      message = "You have exceeded #{@max_balance}!"
      expect { oystercard.top_up(91) }.to raise_error message
      expect(oystercard.balance).to eq (0)
    end
  end

  describe '#in_journey?' do
    it { is_expected.not_to be_in_journey}
  end

  describe '#touch_in' do

    it 'raises an error when the balance is lower than the minimum fare' do
      message = 'Not sufficient balance to continue journey'
      expect{ oystercard.touch_in(entry_station) }.to raise_error message
    end

    it 'in_journey is true once touched in' do
      oystercard.top_up(@min_charge+10)
      oystercard.touch_in(entry_station)
      is_expected.to be_in_journey
    end

    it "remembers the touch in station" do
      oystercard.top_up(@min_charge+10)
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq entry_station
    end
  end

  describe '#touch_out' do
    before(:each) do
      oystercard.top_up(@min_charge+10)
      oystercard.touch_in(entry_station)
    end

    it 'deducts the balance by minimum fare' do
      expect { oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-@min_charge)
    end

    context "have touched in and out" do
      before(:each) do
        oystercard.touch_out(exit_station)
      end

      it 'after touch out sets the entry station to nil' do
        expect(oystercard.entry_station).to eq(nil)
      end

      it "sets exit_station" do
        expect(oystercard.exit_station).to eq exit_station
      end

      it "adds journey to journey_recorder array" do
        #journey = { entry_station: entry_station, exit_station: exit_station }
        expect(oystercard.journey_recorder).to include(journey)
      end

      it "in_journey is false once touched out" do
        is_expected.not_to be_in_journey
      end
    end
  end

end
