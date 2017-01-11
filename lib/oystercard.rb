class Oystercard

  attr_reader :balance, :entry_station, :exit_station, :journeys

  MIN_CHARGE = 1
  MAX_BALANCE = 90

  def initialize(balance = 0)
    @balance = balance
    @entry_station = nil
    @exit_station = nil
    @journeys = []
  end

  def top_up(amount)
    fail "You have exceeded #{MAX_BALANCE}!" if exceeds_max_balance?(@balance + amount)
    @balance += amount
  end

  def touch_in(entry_station, journey = Journey.new)
    message = 'Not sufficient balance to continue journey'
    fail message if below_min_balance?(@balance)
    @entry_station = entry_station
    @exit_station = nil
  end

  def touch_out(exit_station)
    deduct(MIN_CHARGE)
    @exit_station = exit_station
    add_journey
    @entry_station = nil
  end

  def in_journey?
     entry_station != nil
     #!!entry_station
  end

  private

  def add_journey
   @journeys << { entry_station: entry_station, exit_station: exit_station }
  end

  def exceeds_max_balance?(balance)
    balance > MAX_BALANCE
  end

  def below_min_balance?(balance)
    balance < MIN_CHARGE
  end

  def deduct(amount)
    @balance -= amount
  end

end
