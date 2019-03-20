require 'date'
require 'nokogiri'
require 'rest-client'
require 'net/http'
require "uri"

class CurrencyService
  @@baseURL = 'https://si3.bcentral.cl/Bdemovil/BDE/IndicadoresDiarios'

  def getValue(page, unit)
    return page.css('.tableUnits')[unit === :UF ? 0 : 1].css('tbody>tr>td')[1].text.to_f
  end

  def getPage(date)
    uri               = URI.parse @@baseURL
    params            = { :fecha => date }
    uri.query         = URI.encode_www_form(params)
    http              = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl      = true
    http.verify_mode  = OpenSSL::SSL::VERIFY_NONE
    html              = http.get(uri.request_uri)

    page = Nokogiri::HTML( html.body )
  end

  def getCurrentDateReport(previousDollarValue, currentDollarValue, previousUFValue, currentUFValue)
    diffDollar = previousDollarValue != 0 ? currentDollarValue - previousDollarValue : nil
    diffUF = previousUFValue != 0 ? currentUFValue - previousUFValue : nil

    return {
      :usd => {
        :today => currentDollarValue,
        :dif   => diffDollar === 0 ? nil : diffDollar
      },
      :uf => {
        :today => currentUFValue,
        :dif   => diffUF === 0 ? nil : diffUF
      }
    }
  end

  def checkDates(fromDate, toDate)
    today = Date.today

    if(fromDate > today || toDate > today)
      raise 'Wrong arguments: from_date and to_date must be prior to today'
    end
  end

  def historical(from_date, to_date)
    fromDate = Date.parse(from_date)
    toDate = Date.parse(to_date)

    checkDates(fromDate, toDate)

    currentDate = fromDate
    previousDollarValue = 0
    previousUFValue = 0
    report = { }

    while currentDate <= toDate do
      currentDateString = currentDate.strftime()
      currentFormattedDate = currentDate.strftime("%d-%m-%Y")

      begin
        page = getPage(currentFormattedDate)

        currentDollarValue = getValue(page, :DOLLAR)
        currentUFValue = getValue(page, :UF)

        report[currentDateString] =
          getCurrentDateReport(previousDollarValue, currentDollarValue, previousUFValue, currentUFValue)

        previousDollarValue = currentDollarValue
        previousUFValue = currentUFValue
      rescue
        puts "Something went wrong while creating #{currentDate} report"
      end

      currentDate += 1
    end

    return report
  end
end