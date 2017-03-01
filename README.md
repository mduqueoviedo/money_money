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

    require 'money_money'

`Money` class is now ready to use.


##### Adding conversion rates:

    Money.conversion_rates('EUR', {'USD' => 1.1, 'CLP' => 650})

##### Creating and manipulating Money objects:

    m = Money.new(10, 'EUR')
    m.amount    # 10
    m.currency  # 'EUR'
    m.inspect   # '10.00 EUR'

##### Currency conversion:

    dollars = m.convert_to('USD')
    dollars.amount    # 11
    dollars.currency  # 'USD'
    dollars.inspect   # '11.00 USD'
    
    pesos = dollars.convert_to('CLP')
    pesos.inspect # '6500.00 CLP'

##### Arithmetic:

##### Comparison:


## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests. You can also run `bundle console` for an interactive prompt with the gem already loaded that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mduqueoviedo/money_money.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

