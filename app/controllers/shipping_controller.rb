require 'active_shipping'

class ShippingController < ApplicationController
  def show
    if params[:id]=="ups"
      ups = ActiveShipping::UPS.new(:login => ENV['ACTIVESHIPPING_UPS_LOGIN'], :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'], :key => ENV['ACTIVESHIPPING_UPS_KEY'])
      response = ups.find_rates(origin, destination, packages)
      rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, date(rate)]}
      status = 200
      raise
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
    
    def date(rate)
      if rate.delivery_date != nil
          date = Date.strptime("#{rate.delivery_date}")
      else
        date = rate.delivery_date
      end
      return date
    end
end
