class Oystercard

  attr_reader :balance
  MAX_BALANCE = 90

  def initialize(balance=0)
    @balance = balance
  end

  def top_up(amount)
    fail "Max balance is 90" if exceed?(@balance + amount)
    @balance += amount
  end

  private

  def exceed?(balance)
    true if balance > MAX_BALANCE
  end
end
