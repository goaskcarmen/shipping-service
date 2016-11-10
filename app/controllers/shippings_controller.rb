class ShippingsController < ApplicationController

  def find_rate
    unless params.keys.include?("weight") && params.keys.include?("origin_zip") && params.keys.include?("dest_zip")
      results = ["please provide params"]
      status = :bad_request
    else

      packages = ActiveShipping::Package.new(params[:weight].to_i, [40, 40, 40])

      origin = ActiveShipping::Location.new(country: 'US', zip: params[:origin_zip])

      destination = ActiveShipping::Location.new(country: 'US', zip: params[:dest_zip])

      ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PWD"], key: ENV["UPS_KEY"])
      response = ups.find_rates(origin, destination, packages)

      # fedex = ActiveShipping::FedEx.new(login: ENV["FEDEX_LOGIN"], password: ENV["FEDEX_PWD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACNT"])
      # response = fedex.find_rates(origin, destination, packages)
      results = parseResponse(response)
      status = :ok
    end

      render :json => results, :status => status
    # @ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # @fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

  end

  def parseResponse(response)
    results = []
    rates = response.rates
    rates.each do |shipping_stuff|
      results << {name: shipping_stuff.service_name, cost: "$#{((shipping_stuff.total_price)/100.0).round(2)}"}
    end
    return results
  end

end
