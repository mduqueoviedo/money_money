require 'spec_helper'

describe MoneyMoney do
  it 'has a version number' do
    expect(MoneyMoney::VERSION).not_to be nil
  end

  describe 'new' do
    let(:ten_euro) { Money.new(10, 'EUR') }

    it 'instantiates class' do
      expect(ten_euro).to be_a(Money)
    end
  end

  describe 'amount' do
    let(:ten_euro) { Money.new(10, 'EUR') }
    let(:five_point_five_euro) { Money.new(5.5, '€') }

    it 'shows amount attribute of object' do
      expect(ten_euro.amount).to eq(10)
      expect(five_point_five_euro.amount).to eq(5.5)
    end
  end

  describe 'currency' do
    let(:ten_euro) { Money.new(10, 'EUR') }
    let(:five_point_five_euro) { Money.new(5.5, '€') }

    it 'shows currency attribute of object' do
      expect(ten_euro.currency).to eq('EUR')
      expect(five_point_five_euro.currency).to eq('€')
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
        Money.conversion_rates('EUR', 'USD' => 1.1, 'CLP' => 500)
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

      it 'converts money between defined currencies' do
        res = five_dollars.convert_to('CLP')

        expect(res.amount.round(2)).to eq(2272.73)
        expect(res.currency).to eq('CLP')
        expect(res.inspect).to eq('2272.73 CLP')
        expect(res).to be_a(Money)
      end
    end

    context 'rate is not defined' do
      it 'throws error when converting' do
        expect { Money.new(50, 'yen').convert_to('cny') }
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
      expect { Money.conversion_rates('EUR', 'USD' => 1.5, 'pts' => 166.386) }
        .not_to raise_error
    end

    it 'does not allow non hash object' do
      expect { Money.conversion_rates('EUR', 'killer parameter') }
        .to raise_error(TypeError, 'You must pass a hash as a set of rates for specified currency.')
    end

    it 'adds conversion rates to an existing conversion rate' do
      expect { Money.conversion_rates('EUR', 'USD' => 1.5, 'pts' => 166.386) }
        .not_to raise_error
      expect { Money.conversion_rates('EUR', 'CAD' => 2.5) }
        .not_to raise_error

      expect(Money.new(10, 'EUR').convert_to('USD')).to be_a(Money)
      expect(Money.new(10, 'EUR').convert_to('CAD')).to be_a(Money)
    end
  end

  describe '+' do
    context 'same currencies' do
      let(:ten_euro) { Money.new(10, 'EUR') }
      let(:twenty_euro) { Money.new(20, 'EUR') }

      it 'adds two money objects of same currency' do
        res = ten_euro + twenty_euro

        expect(res.amount).to eq(30)
        expect(res.currency).to eq('EUR')
        expect(res.inspect).to eq('30.00 EUR')
        expect(ten_euro + twenty_euro).to be_a(Money)
      end
    end

    context 'different currencies' do
      context 'rates defined' do
        let(:ten_euro) { Money.new(10, 'EUR') }
        let(:twenty_dollar) { Money.new(20, 'USD') }

        before do
          Money.conversion_rates('EUR', 'USD' => 1.1)
        end

        it 'adds money objects of different currencies' do
          res = ten_euro + twenty_dollar

          expect(res.amount.round(2)).to eq(28.18)
          expect(res.currency).to eq('EUR')
          expect(res.inspect).to eq('28.18 EUR')
        end
      end

      context 'rates not defined' do
        let(:eighty_dollars) { Money.new(80, 'USD') }
        let(:sixty_yuan) { Money.new(60, 'CNY') }

        it 'throws error when trying to add' do
          expect { eighty_dollars + sixty_yuan }
            .to raise_error(
              'Currently there is no value for requested currency'
            )
        end
      end
    end

    it 'shows error when not adding money object' do
      expect { Money.new(100, 'EUR') + 'error generator' }
        .to raise_error(
          TypeError,
          'the object to operate with is not a Money object. E.g. money_1 + money_2'
        )
    end
  end

  describe '-' do
    context 'same currencies' do
      let(:eighty_dollars) { Money.new(80, 'USD') }
      let(:sixty_dollars) { Money.new(60, 'USD') }

      it 'substracts two money objects' do
        res = eighty_dollars - sixty_dollars

        expect(res.amount).to eq(20)
        expect(res.currency).to eq('USD')
        expect(res.inspect).to eq('20.00 USD')
        expect(eighty_dollars - sixty_dollars).to be_a(Money)
      end
    end

    context 'different currencies' do
      context 'rates defined' do
        let(:fifty_euro) { Money.new(50, 'EUR') }
        let(:twenty_dollar) { Money.new(20, 'USD') }

        before do
          Money.conversion_rates('EUR', 'USD' => 1.1)
        end

        it 'substracts money objects' do
          res = fifty_euro - twenty_dollar

          expect(res.amount.round(2)).to eq(31.82)
          expect(res.currency).to eq('EUR')
          expect(res.inspect).to eq('31.82 EUR')
        end
      end

      context 'rates not defined' do
        let(:eighty_dollars) { Money.new(80, 'USD') }
        let(:sixty_yuan) { Money.new(60, 'CNY') }

        it 'throws error when performing operation' do
          expect { eighty_dollars - sixty_yuan }
            .to raise_error(
              'Currently there is no value for requested currency'
            )
        end
      end
    end

    it 'shows error when not substracting money object' do
      expect { Money.new(80, 'ESP') - 'error generator' }
        .to raise_error(
          TypeError,
          'the object to operate with is not a Money object. E.g. money_1 - money_2'
        )
    end
  end

  describe '*' do
    it 'multiplies money object times a number' do
      res = Money.new(10, 'EUR') * 4

      expect(res.amount).to eq(40)
      expect(res.currency).to eq('EUR')
      expect(res.inspect).to eq('40.00 EUR')
      expect(Money.new(10, 'EUR') * 4).to be_a(Money)
    end

    it 'throws error when parameter is not a number' do
      expect { Money.new(100, 'EUR') * 'error generator' }
        .to raise_error(
          TypeError, 'this operation requires a number. E.g. money * 2'
        )
    end
  end

  describe '/' do
    it 'divides money object by a number' do
      res = Money.new(10, 'EUR') / 4

      expect(res.amount).to eq(2.5)
      expect(res.currency).to eq('EUR')
      expect(res.inspect).to eq('2.50 EUR')
      expect(Money.new(10, 'EUR') / 4).to be_a(Money)
    end

    it 'throws error when parameter is not a number' do
      expect { Money.new(100, 'EUR') / 'error generator' }
        .to raise_error(
          TypeError, 'this operation requires a number. E.g. money / 2'
        )
    end
  end

  describe 'comparators' do
    context 'same currency' do
      it 'compares money objects' do
        expect(Money.new(10, 'EUR') == Money.new(10.0, 'EUR')).to be true
        expect(Money.new(10, 'EUR') == Money.new(11, 'EUR')).to be false
        expect(Money.new(10.001, 'EUR') == Money.new(10, 'EUR')).to be true

        expect(Money.new(20, 'EUR') > Money.new(10, 'EUR')).to be true
        expect(Money.new(20, 'EUR') > Money.new(20.0, 'EUR')).to be false
        expect(Money.new(10, 'EUR') > Money.new(20, 'EUR')).to be false

        expect(Money.new(20, 'EUR') < Money.new(10, 'EUR')).to be false
        expect(Money.new(10, 'EUR') < Money.new(10.0, 'EUR')).to be false
        expect(Money.new(10, 'EUR') < Money.new(20, 'EUR')).to be true

        expect(Money.new(20, 'EUR') >= Money.new(10, 'EUR')).to be true
        expect(Money.new(20, 'EUR') >= Money.new(20.0, 'EUR')).to be true
        expect(Money.new(10, 'EUR') >= Money.new(20, 'EUR')).to be false

        expect(Money.new(20, 'EUR') <= Money.new(10, 'EUR')).to be false
        expect(Money.new(10, 'EUR') <= Money.new(10.0, 'EUR')).to be true
        expect(Money.new(10, 'EUR') <= Money.new(20, 'EUR')).to be true
      end
    end

    context 'different currencies' do
      before do
        Money.conversion_rates('EUR', 'USD' => 2)
      end

      it 'compares money objects' do
        expect(Money.new(10, 'EUR') == Money.new(20, 'USD')).to be true
        expect(Money.new(10, 'EUR') == Money.new(22, 'USD')).to be false
        expect(Money.new(10.001, 'EUR') == Money.new(20, 'USD')).to be true

        expect(Money.new(20, 'EUR') > Money.new(20, 'USD')).to be true
        expect(Money.new(20, 'EUR') > Money.new(40, 'USD')).to be false
        expect(Money.new(10, 'EUR') > Money.new(40, 'USD')).to be false

        expect(Money.new(20, 'EUR') < Money.new(20, 'USD')).to be false
        expect(Money.new(10, 'EUR') < Money.new(20, 'USD')).to be false
        expect(Money.new(10, 'EUR') < Money.new(40, 'USD')).to be true

        expect(Money.new(20, 'EUR') >= Money.new(20, 'USD')).to be true
        expect(Money.new(20, 'EUR') >= Money.new(40, 'USD')).to be true
        expect(Money.new(10, 'EUR') >= Money.new(40, 'USD')).to be false

        expect(Money.new(20, 'EUR') <= Money.new(20, 'USD')).to be false
        expect(Money.new(10, 'EUR') <= Money.new(20, 'USD')).to be true
        expect(Money.new(10, 'EUR') <= Money.new(40, 'USD')).to be true
      end
    end
  end
end
