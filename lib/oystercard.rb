class Oystercard

  attr_reader :balance, :entry_station
  MIN_CHARGE = 1
  MAX_BALANCE = 90

  def initialize(balance = 0)
    @balance = balance
  end

  def top_up(amount)
    fail "You have exceeded #{MAX_BALANCE}!" if exceed?(@balance + amount)
    @balance += amount
  end

  def touch_in(station)
    message = 'Not sufficient balance to continue journey'
    fail message if insufficient_balance?(@balance)
    @entry_station = station
    in_journey?
  end

  def touch_out
    deduct(MIN_CHARGE)
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
