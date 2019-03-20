require_relative "CurrencyService"
require 'pp'

currencyService = CurrencyService.new
report = currencyService.historical('1-03-2019', '17-03-2019')

pp report
