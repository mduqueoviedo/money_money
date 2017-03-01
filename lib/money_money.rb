require "money_money/version"
require "money_money/comparators"
require "money_money/operations"

class Money
  @@conversion_table = {}

  attr_reader :amount, :currency

  include MoneyMoney::Comparators
  include MoneyMoney::Operations

  def initialize(amount, currency)
    puts 'Specified currency is not defined, you will not ' \
         'be able to perform conversion operations unless ' \
         'you define rates with \'conversion_rates\' command.' unless self.class.defined_currency?(currency)

    @amount = amount
    @currency = currency
  end

  def self.conversion_rates(base_currency, rates)
    raise TypeError, 'You must pass a hash as a set of rates for specified currency.' unless rates.is_a?(Hash)

    if @@conversion_table[base_currency]
      @@conversion_table[base_currency] = @@conversion_table[base_currency].merge(rates)
    else
      @@conversion_table[base_currency] = rates
    end
  end

  def convert_to(dest_currency)
    raise 'Currently there is no value for requested currency' unless self.class.has_rate?(self.currency, dest_currency)

    conv_rate = self.class.get_rate(self.currency, dest_currency)
    Money.new(self.amount * conv_rate, dest_currency)
  end

  def inspect
    "#{"%.2f" % amount} #{currency}"
  end

  def self.has_rate?(orig_currency, dest_currency)
    conv_table = @@conversion_table # Reduce length a bit

    if orig_currency == dest_currency
      true
    elsif (conv_table[orig_currency] && conv_table[orig_currency][dest_currency]) ||
          (conv_table [dest_currency] && conv_table[dest_currency][orig_currency])
      true # One of them is a base currency
    elsif conv_table.select{|_, hash| hash[orig_currency] && hash[dest_currency]}.count > 0
      true # None of them are base but are defined on the same base
    else
      false
    end
  end

  def self.get_rate(orig_currency, dest_currency)
    conv_table = @@conversion_table
    if orig_currency == dest_currency
      1
    elsif conv_table[orig_currency] && conv_table[orig_currency][dest_currency]
      conv_table[orig_currency][dest_currency]
    elsif conv_table [dest_currency] && conv_table[dest_currency][orig_currency]
      1 / conv_table[dest_currency][orig_currency]
    elsif conv_table.select{|_, hash| hash[orig_currency] && hash[dest_currency]}.count > 0
      orig_rate = conv_table.select{|_, hash| hash[orig_currency] && hash[dest_currency]}.first[1][orig_currency]
      dest_rate = conv_table.select{|_, hash| hash[orig_currency] && hash[dest_currency]}.first[1][dest_currency]
      (1 / orig_rate) * dest_rate
    else
      raise 'Unexpected conversion error.'
    end
  end

  def self.defined_currency?(currency)
    @@conversion_table.has_key?(currency) || @@conversion_table.find{ |_, hash| hash[currency] }
  end

end
