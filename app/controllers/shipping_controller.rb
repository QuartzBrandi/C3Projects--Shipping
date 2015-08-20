require 'active_shipping'
class ShippingController < ApplicationController
  before_action :origin, :destination, :packages

    def show

      if params[:id] == "ups" || params[:id] == "usps"
        status = 200
        if params[:id] == "ups"
          rates = find_rates(ups_carrier)
        else
          rates = find_rates(usps_carrier)
        end

        if rates
          rates = sort_rates(rates)
          text_status = "success"
          message = nil
        else
          text_status = "error"
          message = "Invalid address"
          status = 400
        end
      end

      if params[:id] != "ups" && params[:id] != "usps"
        rates = nil
        status = 400
        text_status = "error"
        message = "Invalid carrier"
      end
      render json: {"status": text_status, "data": rates, "message": message}, status: status
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
      begin
        carrier.find_rates(origin, destination, packages)
      rescue ActiveShipping::ResponseError
        return nil
      end
    end

    def sort_rates(carrier_rates)
      sorted_rates = carrier_rates.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, delivery_date(rate)]}
      return sorted_rates
    end
end
