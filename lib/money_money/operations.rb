module MoneyMoney::Operations
  def +(obj)
    if obj.is_a?(Money)
      Money.new(self.amount + obj.convert_to(self.currency).amount, self.currency)
    else
      raise TypeError, 'the object to operate with is not a Money object. E.g. money_1 + money_2'
    end
  end

  def -(obj)
    if obj.is_a?(Money)
      Money.new(self.amount - obj.convert_to(self.currency).amount, self.currency)
    else
      raise TypeError, 'the object to operate with is not a Money object. E.g. money_1 - money_2'
    end
  end

  def *(num)
    if num.is_a?(Numeric)
      Money.new(self.amount * num, self.currency)
    else
      raise TypeError, 'this operation requires a number. E.g. money * 2'
    end
  end

  def /(num)
    if num.is_a?(Numeric)
      Money.new(self.amount.to_f / num, self.currency)
    else
      raise TypeError, 'this operation requires a number. E.g. money / 2'
    end
  end
end