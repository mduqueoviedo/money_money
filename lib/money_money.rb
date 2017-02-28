require "money_money/version"
require "money_money/comparators"
require "money_money/operations"

class Money
  @@conversion_table = {}

  attr_reader :amount, :currency

  include MoneyMoney::Comparators
  include MoneyMoney::Operations

  def initialize(amount, currency)
    puts 'Specified currency is not defined, you will not be able to perform conversion operations unless you define rates with \'conversion_rates\' command.'
    @amount = amount
    @currency = currency
  end

  def self.conversion_rates(base_currency, rates)
    @@conversion_table[base_currency] = rates if rates.is_a?(Hash)
  end

  def convert_to(dest_currency)
    if self.class.has_rate?(self.currency, dest_currency)
      conv_rate = self.class.get_rate(self.currency, dest_currency)
      Money.new(self.amount * conv_rate, dest_currency)
    else
      raise 'Currently there is no value for requested currency'
    end
  end

  def inspect
    "#{"%.2f" % amount} #{currency}"
  end

  def self.has_rate?(orig_currency, dest_currency)
    if orig_currency == dest_currency
      true
    else
      @@conversion_table[orig_currency].nil? || @@conversion_table[orig_currency][dest_currency].nil? ? false : true
    end
  end

  def self.get_rate(orig_currency, dest_currency)
    if orig_currency == dest_currency
      1
    else
      @@conversion_table[orig_currency][dest_currency]
    end
  end

end
