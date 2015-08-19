require 'active_shipping'

class ShippingController < ApplicationController
  def show
    if params[:id]=="ups"
      rates = find_rates(ups_carrier)
      rates = sort_rates(rates)
      status = 200
    elsif params[:id] == "usps"
      rates = find_rates(usps_carrier)
      rates = sort_rates(rates)
      status = 200
    else
      rates = []
      status = 204
    end
    render json: rates, status: status
  end

  private
    def origin
      ActiveShipping::Location.new( :country => params["origin_country"],
                                    :state => params["origin_state"],
                                    :city => params["origin_city"],
                                    :zip => params["origin_zip"],
                                    :address1 => params["origin_address1"],
                                    :address2 => params["origin_address2"])
    end

    def destination
      ActiveShipping::Location.new( :country => params["destination_country"],
                                    :state => params["destination_state"],
                                    :city => params["destination_city"],
                                    :zip => params["destination_zip"],
                                    :address1 => params["destination_address1"],
                                    :address2 => params["destination_address2"])
    end

    def packages
      ActiveShipping::Package.new( 100,              # 100 grams
                                  [93,10],           # 93 cm long, 10 cm diameter
                                  :cylinder => true)
    end

    def delivery_date(rate)
      if rate.delivery_date != nil
          date = Date.strptime("#{rate.delivery_date}")
      else
        date = rate.delivery_date
      end
      return date
    end

    def ups_carrier
      ActiveShipping::UPS.new(:login => ENV['ACTIVESHIPPING_UPS_LOGIN'], :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'], :key => ENV['ACTIVESHIPPING_UPS_KEY'])
    end

    def usps_carrier
      ActiveShipping::USPS.new(:login => ENV['ACTIVESHIPPING_USPS_LOGIN'])
    end

    def find_rates(carrier)
      carrier.find_rates(origin, destination, packages)
    end

    def sort_rates(carrier_rates)
      if ups_carrier
        sorted_rates = carrier_rates.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, delivery_date(rate)]}
      elsif usps_carrier
        sorted_rates = carrier.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      end
      return sorted_rates
    end
end
