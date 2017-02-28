module MoneyMoney::Operations
  def +(obj)
    if obj.is_a?(Money)
      Money.new(self.amount + obj.convert_to(self.currency).amount, self.currency)
    else
      raise TypeError
    end
  end

  def -(obj)
    if obj.is_a?(Money)
      Money.new(self.amount - obj.convert_to(self.currency).amount, self.currency)
    else
      raise TypeError
    end
  end

  def *(num)
    if num.is_a?(Numeric)
      Money.new(self.amount * num, self.currency)
    else
      raise TypeError
    end
  end

  def /(num)
    if num.is_a?(Numeric)
      Money.new(self.amount / num, self.currency)
    else
      raise TypeError
    end
  end
end