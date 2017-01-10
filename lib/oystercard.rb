class Oystercard

  attr_reader :balance, :in_journey
  MIN_BALANCE = 1
  MAX_BALANCE = 90

  def initialize(balance = 0)
    @balance = balance
    @in_journey = false
  end

  def top_up(amount)
    fail "You have exceeded #{MAX_BALANCE}!" if exceed?(@balance + amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    message = 'Not sufficient balance to continue journey'
    fail message if insufficient_balance?(@balance)
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end

  private

  def exceed?(balance)
    true if balance > MAX_BALANCE
  end

  def insufficient_balance?(balance)
    true if balance < MIN_BALANCE
  end

end
