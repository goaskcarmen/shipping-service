class ShippingsController < ApplicationController

  def find_rate
    results =[]

    unless params.keys.include?("weight") && params.keys.include?("origin_zip") && params.keys.include?("dest_zip")
      results = ["please provide params"]
      status = :bad_request
    else

      packages = ActiveShipping::Package.new(params[:weight].to_i, [40, 40, 40])

      origin = ActiveShipping::Location.new(country: 'US', zip: params[:origin_zip])

      destination = ActiveShipping::Location.new(country: 'US', zip: params[:dest_zip])

      ups_rates = ups(origin, destination, packages)

      fedex_rates = fedex(origin, destination, packages)

      usps_rates = usps(origin, destination, packages)

      results << parseResponse(ups_rates) << parseResponse(fedex_rates) << parseResponse(usps_rates)
      status = :ok
    end

      render :json => results, :status => status

  end

  def parseResponse(rates)
    results = []
    rates.each do |shipping_stuff|
      results << {name: shipping_stuff.service_name, cost: "$#{((shipping_stuff.total_price)/100.0).round(2)}"}
    end
    return results
  end

  def ups(origin, destination, packages)
    ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PWD"], key: ENV["UPS_KEY"])
    ups_response = ups.find_rates(origin, destination, packages)

    return ups_response.rates

  rescue ActiveShipping::ResponseError
    return []
  end

  def fedex(origin, destination, packages)
    fedex = ActiveShipping::FedEx.new(login: ENV["FEDEX_METER_NUM"], password: ENV["FEDEX_PWD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACNT"], test: true)
    fedex_response = fedex.find_rates(origin, destination, packages)

    return fedex_response.rates

  rescue ActiveShipping::ResponseError
    return []
  end

  def usps(origin, destination, packages)
    usps = ActiveShipping::USPS.new(login: ENV["USPS_LOGIN"])
    usps_response = usps.find_rates(origin, destination, packages)

    return usps_response.rates

  rescue ActiveShipping::ResponseError
    return []
  end

end
