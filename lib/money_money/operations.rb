module MoneyMoney
  module Operations
    def +(other)
      raise TypeError, 'the object to operate with is not a Money object. E.g. money_1 + money_2' unless other.is_a?(Money)
      Money.new(amount + other.convert_to(currency).amount, currency)
    end

    def -(other)
      raise TypeError, 'the object to operate with is not a Money object. E.g. money_1 - money_2' unless other.is_a?(Money)
      Money.new(amount - other.convert_to(currency).amount, currency)
    end

    def *(other)
      raise TypeError, 'this operation requires a number. E.g. money * 2' unless other.is_a?(Numeric)
      Money.new(amount * other, currency)
    end

    def /(other)
      raise TypeError, 'this operation requires a number. E.g. money / 2' unless other.is_a?(Numeric)
      Money.new(amount.to_f / other, currency)
    end
  end
end
