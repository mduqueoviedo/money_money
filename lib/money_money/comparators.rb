module MoneyMoney::Comparators
  include Comparable

  def <=>(obj)
    return nil unless obj.is_a?(Money)
    self.amount.round(2) <=> obj.convert_to(self.currency).amount.round(2)
  end
end