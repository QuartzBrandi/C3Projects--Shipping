require 'active_shipping'

class ShippingController < ApplicationController
  def show
    if params[:id]=="ups"
      ups = ActiveShipping::UPS.new(:login => ENV['ACTIVESHIPPING_UPS_LOGIN'], :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'], :key => ENV['ACTIVESHIPPING_UPS_KEY'])
      response = ups.find_rates(origin, destination, packages)
      rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      status = 200
    elsif params[:id] == "usps"
      usps = ActiveShipping::USPS.new(:login => ENV['ACTIVESHIPPING_USPS_LOGIN'])
      response = usps.find_rates(origin, destination, packages)
      rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      status = 200
    else
      rates = []
      status = 204
    end
    render json: rates, status: status
  end

  def origin
    ActiveShipping::Location.new( :country => params["origin_country"],
                                  :state => params["origin_state"],
                                  :city => params["origin_city"],
                                  :zip => params["origin_zip"])
  end

  def destination
    ActiveShipping::Location.new( :country => params["destination_country"],
                                  :state => params["destination_state"],
                                  :city => params["destination_city"],
                                  :zip => params["destination_zip"])
  end

  def packages
    ActiveShipping::Package.new( 100,              # 100 grams
                                [93,10],           # 93 cm long, 10 cm diameter
                                :cylinder => true)
  end
end
