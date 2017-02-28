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
      let(:ten_euro) { Money.new(10, 'EUR') }
      let(:five_dollars) { Money.new(5, 'USD') }

      before do
        Money.conversion_rates('EUR', {'USD' => 1.1})
      end

      it 'converts currency from base to other currency' do
        res = ten_euro.convert_to('USD')

        expect(res.amount).to eq(11)
        expect(res.currency).to eq('USD')
        expect(res.inspect).to eq('11.00 USD')
      end

      it 'converts currency from defined currency to base' do
        res = five_dollars.convert_to('EUR')

        expect(res.amount.round(2)).to eq(4.55)
        expect(res.currency).to eq('EUR')
        expect(res.inspect).to eq('4.55 EUR')
      end

      it 'returns money object' do
        res = ten_euro.convert_to('USD')
        expect(res).to be_a(Money)
      end
    end

    context 'rate is not defined' do
      it 'throws error when converting' do
        expect{ Money.new(50, 'yen').convert_to('cny') }
          .to raise_error('Currently there is no value for requested currency')
      end
    end

    context 'origin and destination currencies are the same' do
      it 'does not throw error even if currency is not defined' do
        converted = Money.new(10, 'pts').convert_to('pts')

        expect(converted).to be_a(Money)
        expect(converted.currency).to eq('pts')
        expect(converted.amount).to eq(10)
      end
    end
  end

  describe 'self.conversion_rates' do
    it 'adds conversion rates to class' do
      expect{ Money.conversion_rates('EUR', {'USD' => 1.5, 'pts' => 166.386})}
        .not_to raise_error
    end

    it 'does not allow non hash object' do
      expect{ Money.conversion_rates('EUR', 'killer parameter')}
        .to raise_error(TypeError, 'You must pass a hash as a set of rates for specified currency.')
    end

    it 'adds conversion rates to an existing conversion rate' do
      expect{ Money.conversion_rates('EUR', {'USD' => 1.5, 'pts' => 166.386}) }
        .not_to raise_error
      expect{ Money.conversion_rates('EUR', {'CAD' => 2.5}) }
        .not_to raise_error

      expect(Money.new(10, 'EUR').convert_to('USD')).to be_a(Money)
      expect(Money.new(10, 'EUR').convert_to('CAD')).to be_a(Money)
    end
  end

  describe '+' do
    it 'adds two money objects of same currency' do
      m = Money.new(10, 'EUR')
      n = Money.new(20, 'EUR')
      res = m + n

      expect(res.amount).to eq(30)
      expect(res.currency).to eq('EUR')
      expect(res.inspect).to eq('30.00 EUR')
    end

    it 'returns money object' do
      m = Money.new(10, 'EUR')
      n = Money.new(20, 'EUR')
      res = m + n

      expect(res).to be_a(Money)
    end

    it 'shows error when not adding money object' do
      expect{ Money.new(100, 'EUR') + 'error generator' }
        .to raise_error(TypeError, 'the object to operate with is not a Money object. E.g. money_1 + money_2')
    end

    context 'rates defined' do
      before do
        Money.conversion_rates('EUR', {'USD' => 1.1})
      end

      it 'adds money objects of different currencies' do

      end
    end

    context 'rates not defined' do
      it 'throws error when trying to add' do
        m = Money.new(80, 'USD')
        n = Money.new(60, 'CNY')
        expect{ m + n }.to raise_error('Currently there is no value for requested currency')
      end
    end
  end

  describe '-' do
    it 'substracts two money objects of same currency' do
      m = Money.new(80, 'USD')
      n = Money.new(60, 'USD')
      res = m - n

      expect(res.amount).to eq(20)
      expect(res.currency).to eq('USD')
      expect(res.inspect).to eq('20.00 USD')
    end

    it 'returns money object' do
      m = Money.new(80, 'USD')
      n = Money.new(60, 'USD')
      res = m - n

      expect(res).to be_a(Money)
    end

    it 'shows error when not substracting money object' do
      expect{ Money.new(100, 'EUR') - 'error generator' }
        .to raise_error(TypeError, 'the object to operate with is not a Money object. E.g. money_1 - money_2')
    end

    context 'rates defined' do
      before do
        Money.conversion_rates('EUR', {'USD' => 1.1})
      end

      it 'substracts money objects of different currencies' do

      end
    end

    context 'rates not defined' do
      it 'throws error when performing operation' do
        m = Money.new(80, 'USD')
        n = Money.new(60, 'CNY')
        expect{ m - n }.to raise_error('Currently there is no value for requested currency')
      end
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
    context 'same currency' do
      it 'compares two money objects and returns true if the amount is the same' do

      end

      it 'compares two money objects and returns false if the amount is not the same' do

      end

      it 'compares two money objects and returns true if amount rounded to two decimals is the same' do

      end
    end

    context 'different currencies' do
      context 'rates defined' do
        before do
          Money.conversion_rates('EUR', {'USD' => 1.1})
        end

        it 'compares two money objects and returns true if the equivalent amount is the same' do

        end

        it 'compares two money objects and returns false if the equivalent amount is not the same' do

        end

        it 'compares two money objects and returns true if equivalent amount rounded to two decimals is the same' do

        end
      end

      context 'rates not defined' do
        it 'throws error when performing operation' do

        end
      end
    end

    it 'throws error when not comparing to a money object' do

    end
  end

  describe '>' do
    context 'same currencies' do
      it 'compares two money objects and returns true if the amount of first is bigger than second' do

      end
      it 'compares two money objects and returns false if the amount of first is smaller than second' do

      end
    end

    context 'different currencies' do
      context 'rates defined' do
        it 'compares two money objects and returns true if the equivalent amount of first is bigger than second' do

        end

        it 'compares two money objects and returns false if the equivalent amount of first is smaller than second' do

        end
      end

      context 'rates not defined' do
        it 'throws error when performing operation' do

        end
      end
    end

    it 'throws error when not comparing to a money object' do

    end
  end

  describe '<' do
    context 'same currencies' do
      it 'compares two money objects and returns true if the amount of first is smaller than second' do

      end

      it 'compares two money objects and returns false if the amount of first is bigger than second' do

      end
    end

    context 'different currencies' do
      context 'rates defined' do
        it 'compares two money objects and returns true if the equivalent amount of first is smaller than second' do

        end

        it 'compares two money objects and returns false if the equivalent amount of first is bigger than second' do

        end
      end

      context 'rates not defined' do
        it 'throws error when performing operation' do

        end
      end
    end

    it 'throws error when not comparing to a money object' do

    end
  end
end
