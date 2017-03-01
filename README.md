# MoneyMoney

MoneyMoney allows to add a Money class to your application, define currency equivalences and operate and convert them.
It might have namespace conflicts with other money gems.

**Disclaimer**: This is an experimental gem for the sake of self-improvement and honing knowledge and development skills. Check www.rubygems.org to look for tested and certified money conversion gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'money_money'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install money_money

## Usage

Include gem in your codebase:

```ruby
require 'money_money'
```

`Money` class is now ready to use.


##### Adding conversion rates:

```ruby
Money.conversion_rates('EUR', {'USD' => 1.1, 'CLP' => 650})
```

##### Creating and manipulating Money objects:

```ruby
m = Money.new(10, 'EUR')

m.amount    
#=> 10
m.currency  
#=> 'EUR'
m.inspect   
#=> '10.00 EUR'
```

##### Currency conversion:

```ruby
dollars = m.convert_to('USD')

dollars.amount    
#=> 11
dollars.currency  
#=> 'USD'
dollars.inspect   
#=> '11.00 USD'

pesos = dollars.convert_to('CLP')

pesos.inspect
#=> '6500.00 CLP'
```

##### Arithmetic:

MoneyMoney allows to add and substract different Money instances and multiply and divide them by numeric values.

```ruby
Money.new(10, 'EUR') + Money.new(20, 'EUR')
#=> 30.00 EUR

# Operations between different defined currencies is supported
Money.new(10, 'EUR') + Money.new(10, 'USD')
#=> 21.00 EUR

Money.new(20, 'EUR') - Money.new(10, 'USD')
#=> 9.00 EUR

Money.new(15, 'EUR') * 3
#=> 45.00 EUR

Money.new(60, 'USD') / 4
#=> 15.00 USD
```

##### Comparison:

MoneyMoney also supports comparators (==, <, >).

```ruby
Money.new(10, 'EUR') == Money.new(10, 'EUR')
#=> true

# Operations between different defined currencies is supported
Money.new(10, 'EUR') == Money.new(11, 'USD')
#=> true

Money.new(10, 'EUR') == Money.new(15, 'USD')
#=> false

Money.new(20, 'EUR') > Money.new(10, 'USD')
#=> true

Money.new(20, 'EUR') < Money.new(10, 'USD')
#=> false
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests. You can also run `bundle console` for an interactive prompt with the gem already loaded that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mduqueoviedo/money_money.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
