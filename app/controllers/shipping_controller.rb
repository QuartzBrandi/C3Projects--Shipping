require 'active_shipping'

class ShippingController < ApplicationController

#   def index
#     packages = [
#       ActiveShipping::Package.new( 100,                  # 100 grams
#                                    [93,10],              # 93 cm long, 10 cm diameter
#                                    :cylinder => true),   # cylinders have different volume calculations
#
#       ActiveShipping::Package.new( 7.5 * 16,             # 7.5 lbs, times 16 oz/lb.
#                                    [15, 10, 4.5],        # 15x10x4.5 inches
#                                    :units => :imperial)  # not grams, not centimetres
#     ]
#
# # {"country":"US","postal_code":"90210","province":"CA","city":"Beverly Hills","name":null,"address1":null,"address2":null,"address3":null,"phone":null,"fax":null,"address_type":null,"company_name":null}
#     origin = ActiveShipping::Location.new( :country => 'US',
#                                            :state => 'CA',
#                                            :city => 'Beverly Hills',
#                                            :zip => '90210')
# # {"country":"CA","postal_code":"K1P 1J1","province":"ON","city":"Ottawa","name":null,"address1":null,"address2":null,"address3":null,"phone":null,"fax":null,"address_type":null,"company_name":null}
#     destination = ActiveShipping::Location.new( :country => 'CA',
#                                                 :province => 'ON',
#                                                 :city => 'Ottawa',
#                                                 :postal_code => 'K1P 1J1')
#
#     ups = ActiveShipping::UPS.new(:login => ENV['ACTIVESHIPPING_UPS_LOGIN'], :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'], :key => ENV['ACTIVESHIPPING_UPS_KEY'])
#     response = ups.find_rates(origin, destination, packages)
#     raise
#
#     ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
#     # => [["UPS Standard", 3936],
#     #     ["UPS Worldwide Expedited", 8682],
#     #     ["UPS Saver", 9348],
#     #     ["UPS Express", 9702],
#     #     ["UPS Worldwide Express Plus", 14502]]
#
#     # Check out USPS for comparison...
#     usps = ActiveShipping::USPS.new(:login => ENV['ACTIVESHIPPING_USPS_LOGIN'])
#     response = usps.find_rates(origin, destination, packages)
#
#     usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
#     # => [["USPS Priority Mail International", 4110],
#     #     ["USPS Express Mail International (EMS)", 5750],
#     #     ["USPS Global Express Guaranteed Non-Document Non-Rectangular", 9400],
#     #     ["USPS GXG Envelopes", 9400],
#     #     ["USPS Global Express Guaranteed Non-Document Rectangular", 9400],
#     #     ["USPS Global Express Guaranteed", 9400]]
#
#     render json: [ups_rates, usps_rates].flatten
#
#     end

  # def show
  #   destination = ActiveShipping::Location.new( :country => params["destination_country"],
  #                                               :state => params["destination_state"],
  #                                               :city => params["destination_city"],
  #                                               :zip => params["destination_zip"])
  #   render json: destination
  # end
  #
  #
#
  def answer
    ups = ActiveShipping::UPS.new(:login => ENV['ACTIVESHIPPING_UPS_LOGIN'], :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'], :key => ENV['ACTIVESHIPPING_UPS_KEY'])
    response = ups.find_rates(origin, destination, packages)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    usps = ActiveShipping::USPS.new(:login => ENV['ACTIVESHIPPING_USPS_LOGIN'])
    response1 = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    render json: [ups_rates, usps_rates].flatten
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
    packages = ActiveShipping::Package.new( 100,     # 100 grams
                                 [93,10],            # 93 cm long, 10 cm diameter
                                :cylinder => true)
  end
end
