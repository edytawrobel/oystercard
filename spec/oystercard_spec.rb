require 'oystercard'

describe Oystercard do
  subject(:oystercard) (described_class.new)
  describe 'initialization' do
    it 'is created with a balance of zero by default' do
      expect(oystercard.balance).to eq(0)
    end
  end

  context '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect{ subject.top_up 10 }.to change{ subject.balance }.by 10
    end

    it 'can be topped up with a specific amount' do
      subject.top_up(20)
      expect(subject.balance).to eq(20)
    end

    it 'raises an error if the balance exceeds the max limit' do
      max_balance = described_class::MAX_BALANCE
      message = "You have exceeded #{max_balance}!"
      subject.top_up(max_balance)
      expect { subject.top_up(1) }.to raise_error message
    end

    it 'raises an error if the maximum balance is exceeded' do
      max_balance = described_class::MAX_BALANCE
      subject.top_up max_balance
      expect{ subject.top_up 1 }.to raise_error "You have exceeded #{max_balance}!"
    end

    it 'raises an error when the balance exceeds the max limit' do
      max_balance = described_class::MAX_BALANCE
      message = "You have exceeded #{max_balance}!"
      expect { subject.top_up(91) }.to raise_error message
      expect(subject.balance).to eq (0)
    end

  end

end
