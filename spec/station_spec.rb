require 'station'
describe Station do

  subject(:station) { described_class.new(:name, :zone) }

  it 'knows its name' do
    expect(station.name).to eq(:name)
  end

  it 'knows its zone' do
    expect(station.zone).to eq(:zone)
  end
end
