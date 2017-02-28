module MoneyMoney::Comparators
  def ==(obj)
    if obj.is_a?(Money)
      self.amount.round(2) == obj.convert_to(self.currency).amount.round(2)
    else
      raise TypeError
    end
  end

  def >(obj)
    if obj.is_a?(Money)
      self.amount.round(2) > obj.convert_to(self.currency).amount.round(2)
    else
      raise TypeError
    end
  end

  def <(obj)
    if obj.is_a?(Money)
      self.amount.round(2) < obj.convert_to(self.currency).amount.round(2)
    else
      raise TypeError
    end
  end
end