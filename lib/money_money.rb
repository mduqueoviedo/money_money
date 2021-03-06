require 'money_money/version'
require 'money_money/operations'
require 'money_money/comparators'

class Money
  @conversion_table = {}

  attr_reader :amount, :currency

  include MoneyMoney::Operations
  include MoneyMoney::Comparators

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def self.conversion_rates(base_currency, rates)
    raise TypeError, 'You must pass a hash as a set of rates for specified currency.' unless rates.is_a?(Hash)

    @conversion_table[base_currency] = @conversion_table[base_currency] ? @conversion_table[base_currency].merge(rates) : rates
  end

  def convert_to(dest_currency)
    raise 'Currently there is no value for requested currency' unless self.class.rate?(currency, dest_currency)

    conv_rate = self.class.get_rate(currency, dest_currency)
    Money.new(amount * conv_rate, dest_currency)
  end

  def inspect
    "#{'%.2f' % amount} #{currency}"
  end

  def self.rate?(orig_currency, dest_currency)
    conv_table = @conversion_table # For clearer code

    if orig_currency == dest_currency
      true
    elsif (conv_table[orig_currency] && conv_table[orig_currency][dest_currency]) ||
          (conv_table [dest_currency] && conv_table[dest_currency][orig_currency])
      true # One of them is a base currency
    elsif conv_table.select { |_, hash| hash[orig_currency] && hash[dest_currency] }.count > 0
      true # None of them are base but are defined on the same base
    else
      false
    end
  end

  def self.get_rate(orig_currency, dest_currency)
    conv_table = @conversion_table
    if orig_currency == dest_currency
      1
    elsif conv_table[orig_currency] && conv_table[orig_currency][dest_currency]
      conv_table[orig_currency][dest_currency]
    elsif conv_table[dest_currency] && conv_table[dest_currency][orig_currency]
      1 / conv_table[dest_currency][orig_currency]
    elsif conv_table.select { |_, hash| hash[orig_currency] && hash[dest_currency] }.count > 0
      found_rates_hash = conv_table.select { |_, hash| hash[orig_currency] && hash[dest_currency] }.first[1]

      orig_rate = found_rates_hash[orig_currency]
      dest_rate = found_rates_hash[dest_currency]

      (1 / orig_rate) * dest_rate
    else
      raise 'Unexpected conversion error. Are your currency rates well defined?'
    end
  end

  def self.defined_currency?(currency)
    @conversion_table.key?(currency) || @conversion_table.find { |_, hash| hash[currency] }
  end

  def self.clean_conversion_rates
    @conversion_table = {}
  end
end
