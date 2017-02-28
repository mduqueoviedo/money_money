require "money_money/version"
require "money_money/comparators"
require "money_money/operations"

class Money
  @@conversion_table = {}

  attr_reader :amount, :currency

  include MoneyMoney::Comparators
  include MoneyMoney::Operations

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def self.conversion_rates(base_currency, rates)
    @@conversion_table[base_currency] = rates if rates.is_a?(Hash)
  end

  def convert_to(dest_currency)
    if self.has_rate?(dest_currency)
      conv_rate = self.get_rate(dest_currency)
      Money.new(self.amount * conv_rate, dest_currency)
    else
      raise 'Currently there is no value for requested currency'
    end
  end

  def inspect
    "#{"%.2f" % amount} #{currency}"
  end

  def has_rate?(dest_rate)
    @@conversion_table[self.currency].nil? || @@conversion_table[self.currency][dest_rate].nil? ? false : true
  end

  def get_rate(dest_rate)
    @@conversion_table[self.currency][dest_rate]
  end

end

