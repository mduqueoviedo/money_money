require 'spec_helper'

describe MoneyMoney do
  it 'has a version number' do
    expect(MoneyMoney::VERSION).not_to be nil
  end

  describe 'new' do
    it 'instantiates class' do
      m = Money.new(10, 'EUR')
      expect(m).to be_a(Money)
    end

    it 'shows warning when object has no rate definition' do
      expect { Money.new(10, 'EUR') }
        .to output("Specified currency is not defined, you will not be able to perform conversion operations unless you define rates with \'conversion_rates\' command.\n")
        .to_stdout
    end

    it 'does not show warning when object currency is defined' do
      expect { Money.new(10, 'EUR') }
        .not_to output("Specified currency is not defined, you will not be able to perform conversion operations unless you define rates with \'conversion_rates\' command.\n")
        .to_stdout
    end
  end

  describe 'amount' do
    it 'shows amount attribute of object' do
      expect(Money.new(10, 'EUR').amount).to eq(10)
      expect(Money.new(5.5, 'EUR').amount).to eq(5.5)
    end
  end

  describe 'currency' do
    it 'shows currency attribute of object' do
      expect(Money.new(10, 'EUR').currency).to eq('EUR')
      expect(Money.new(5.5, '€').currency).to eq('€')
    end
  end

  describe 'inspect' do
    it 'prints money object with two decimals' do
      expect(Money.new(10, 'EUR').inspect).to eq('10.00 EUR')
      expect(Money.new(10.1, 'EUR').inspect).to eq('10.10 EUR')
      expect(Money.new(10.12, 'EUR').inspect).to eq('10.12 EUR')
      expect(Money.new(10.153, 'EUR').inspect).to eq('10.15 EUR')
      expect(Money.new(10.156, 'EUR').inspect).to eq('10.16 EUR')
      expect(Money.new(10, '€').inspect).to eq('10.00 €')
    end
  end

  describe 'convert_to' do
    context 'rate is defined' do

    end

    context 'rate is not defined' do

    end

    context 'origin and destination currencies are the same' do

    end
  end

  describe 'self.conversion_rates' do
    it 'adds conversion rates to class' do

    end

    it 'does not allow non hash object' do

    end

    it 'adds conversion rates to an existing conversion rate' do

    end
  end

  describe '+' do
    it 'adds two money objects of same currency' do

    end

    it 'adds money objects of different currencies' do

    end

    it 'throws error when rate is not defined' do

    end

    it 'returns money object' do

    end

    it 'shows error when not adding money object' do

    end
  end

  describe '-' do
    it 'substracts two money objects of same currency' do

    end

    it 'substracts money objects of different currencies' do

    end

    it 'throws error when rate is not defined' do

    end

    it 'returns money object' do

    end

    it 'shows error when not substracting money object' do

    end
  end

  describe '*' do
    it 'multiplies money object times a number' do

    end

    it 'throws error when parameter is not a number' do

    end

    it 'returns money object' do

    end
  end

  describe '/' do
    it 'divides money object by a number' do

    end

    it 'throws error when parameter is not a number' do

    end

    it 'returns money object' do

    end
  end

  describe '==' do
    it 'compares two money objects of same currency and returns true if the amount is the same' do

    end

    it 'compares two money objects of different currency and returns true if the equivalent amount is the same' do

    end

    it 'compares two money objects of same currency and returns false if the amount is not the same' do

    end

    it 'compares two money objects of different currency and returns false if the equivalent amount is not the same' do

    end

    it 'compares two money objects of same currency and returns true if amount rounded to two decimals is the same' do

    end

    it 'compares two money objects of different currency and returns true if equivalent amount rounded to two decimals is the same' do

    end
  end

  describe '>' do
    it 'compares two money objects of same currency and returns true if the amount of first is bigger than second' do

    end

    it 'compares two money objects of different currency and returns true if the amount of first is bigger than second' do

    end

    it 'compares two money objects of same currency and returns false if the amount of first is smaller than second' do

    end

    it 'compares two money objects of different currency and returns false if the equivalent amount of first is smaller than second' do

    end
  end

  describe '<' do
    it 'compares two money objects of same currency and returns true if the amount of first is smaller than second' do

    end

    it 'compares two money objects of different currency and returns true if the amount of first is smaller than second' do

    end

    it 'compares two money objects of same currency and returns false if the amount of first is bigger than second' do

    end

    it 'compares two money objects of different currency and returns false if the equivalent amount of first is bigger than second' do

    end
  end
end
