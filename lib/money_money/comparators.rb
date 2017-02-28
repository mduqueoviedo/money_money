module MoneyMoney::Comparators
  def ==(obj)
    if obj.is_a?(Money)
      self.amount.round(2) == obj.convert_to(self.currency).amount.round(2)
    else
      raise TypeError, 'the object to compare with is not a Money object. E.g. money_1 == money_2'
    end
  end

  def >(obj)
    if obj.is_a?(Money)
      self.amount.round(2) > obj.convert_to(self.currency).amount.round(2)
    else
      raise TypeError, 'the object to compare with is not a Money object. E.g. money_1 > money_2'
    end
  end

  def <(obj)
    if obj.is_a?(Money)
      self.amount.round(2) < obj.convert_to(self.currency).amount.round(2)
    else
      raise TypeError, 'the object to compare with is not a Money object. E.g. money_1 < money_2'
    end
  end
end