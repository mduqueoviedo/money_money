$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'money_money'

RSpec.configure do |config|
  config.append_after(:each) do
    Money.clean_conversion_rates
  end

  # Random specs mean no order dependencies
  config.order = 'random'
end
