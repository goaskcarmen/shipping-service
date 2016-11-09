class ShippingsController < ApplicationController

attr_reader :ups_rates, :fedex_rates

  def find_rate
    packages = ActiveShipping::Package.new(params[:weight].to_i, [40, 40, 40])

    origin = ActiveShipping::Location.new(country: 'US', zip: params[:origin_zip])

    destination = ActiveShipping::Location.new(country: 'US', zip: params[:dest_zip])

    ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PWD"], key: ENV["UPS_KEY"])
    response = ups.find_rates(origin, destination, packages)

    # fedex = ActiveShipping::FedEx.new(login: ENV["FEDEX_LOGIN"], password: ENV["FEDEX_PWD"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACNT"])
    # response = fedex.find_rates(origin, destination, packages)
    results = parseResponse(response)
    # send back to petsy:
    # @ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    render json: results
    # @fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}


    # calc using AS gem
    # save shipping methods as models in our db.
    # send back response to pesty
  end

  def parseResponse(response)
    results = []
    rates = response.rates
    rates.each do |shipping_stuff|
      results << {name: shipping_stuff.service_name, cost: "$#{((shipping_stuff.total_price)/100.0).round(2)}"}
    end
    return results
  end

  def create

  end

end
