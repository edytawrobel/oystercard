class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journey_recorder

  MIN_CHARGE = 1
  MAX_BALANCE = 90

  def initialize(balance = 0)
    @balance = balance
    @journey_recorder = []
  end

  def top_up(amount)
    fail "You have exceeded #{MAX_BALANCE}!" if exceed?(@balance + amount)
    @balance += amount
  end

  def touch_in(station)
    @one_journey = {}
    message = 'Not sufficient balance to continue journey'
    fail message if insufficient_balance?(@balance)
    @entry_station = station
    in_journey?
  end

  def touch_out(station)
    deduct(MIN_CHARGE)
    @exit_station = station
    @one_journey = { entry_station => @entry_station, exit_station => @exit_station }
    @journey_recorder << @one_journey
    @entry_station = nil
    in_journey?
  end

  def in_journey?
     #entry_station != nil
     !!entry_station
  end

  private

  def exceed?(balance)
    true if balance > MAX_BALANCE
  end

  def insufficient_balance?(balance)
    true if balance < MIN_CHARGE
  end

  def deduct(amount)
    @balance -= amount
  end

end
