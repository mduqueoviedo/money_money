module MoneyMoney
  module Comparators
    include Comparable

    def <=>(other)
      return nil unless other.is_a?(Money)

      self.amount.round(2) <=> other.convert_to(currency).amount.round(2)
    end
  end
end
