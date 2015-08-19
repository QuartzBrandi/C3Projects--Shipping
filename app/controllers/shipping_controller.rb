require 'active_shipping'
class ShippingController < ApplicationController
  before_action :origin, :destination, :packages

    def show
      if params[:id] == "ups" || params[:id] == "usps"
        if params[:id] == "ups"
          rates = find_rates(ups_carrier)
          rates = sort_rates(rates)
          status = 200
        elsif params[:id] == "usps"
          rates = find_rates(usps_carrier)
          rates = sort_rates(rates)
          status = 200
        end
        render json: {"status": "success", "data": rates, "message": nil}, status: status
      end

      if params[:id] != "ups" && params[:id] != "usps"
        rates = []
        status = 204
        render json: { "status": "error", "data": nil, "message": "Error has occurred"}, status: status
      end
    end

  private

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
