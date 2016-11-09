class ShippingsController < ApplicationController

attr_reader :ups_rates, :fedex_rates

  def find_rate
    packages = ActiveShipping::Package.new(weight: params[:weight], dimensions: params[:dimensions], options = {params[:options]})

    origin = ActiveShipping::Location.new(country: params[:country], state: params[:state], city: params[:city], zip: params[:zip])

    destination = ActiveShipping::Location.new(country: params[:country], state: params[:state], city: params[:city], zip: params[:zip])

    ups = ActiveShipping::UPS.new(login: UPS_LOGIN, password: UPS_PWD, key: UPS_KEY)
    response = ups.find_rates(origin, destination, packages)

    fedex = ActiveShipping::FedEx.new(login: FEDEX_LOGIN, password: FEDEX_PWD, key: FEDEX_KEY, account: FEDEX_ACNT)
    response = fedex.find_rates(origin, destination, packages)

    # send back to petsy:
    @ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    1.blah 20$
    @chosen = 2.blah 30$
    3.


    @fedex_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}


    # calc using AS gem
    # save shipping methods as models in our db.
    # send back response to pesty
  end

  def create

  end

end
