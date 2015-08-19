require 'active_shipping'

class ShippingController < ApplicationController
    shipping/:id

  def show
    if params[:id] == "ups"
      response = ups
    elsif params[:id] == "usps"
      response = usps
    else
      rsponse = []
    end

      render json: response
  end



  def index
    # Package up a poster and a Wii for your nephew.
    packages = [
      ActiveShipping::Package.new( 100,                  # 100 grams
                                   [93,10],              # 93 cm long, 10 cm diameter
                                   :cylinder => true),   # cylinders have different volume calculations

      ActiveShipping::Package.new( 7.5 * 16,             # 7.5 lbs, times 16 oz/lb.
                                   [15, 10, 4.5],        # 15x10x4.5 inches
                                   :units => :imperial)  # not grams, not centimetres
    ]
    #
    # shipping/:id
    # http://localhost:3000/shipping/q=address=US_CA_Beverly+Hills_90202&
    # shipping?country=US&state=CA&address=BeverlyHills
    #
    # params[:id] = "US_CA_Beverly+Hills_90202"
    #
    # params[:id].split(/_/)
    # address_info = ["US", "CA", "Beverly+Hills", "90202"]
    # :country = address_info[0]
    #
    # render json: info_you_requested

# small_box =

    # You live in Beverly Hills, he lives in Ottawa
    origin = ActiveShipping::Location.new(
                                           :city => 'Beverly Hills',
                                           :zip => '90210')

    destination = ActiveShipping::Location.new( :country => 'CA',
                                                :province => 'ON',
                                                :city => 'Ottawa',
                                                :postal_code => 'K1P 1J1')

    # Find out how much it'll be.
    ups = ActiveShipping::UPS.new(:login => ENV['ACTIVESHIPPING_USPS_LOGIN'], :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'], :key => ENV['ACTIVESHIPPING_UPS_KEY'])
    response = ups.find_rates(origin, destination, packages)

    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # => [["UPS Standard", 3936],
    #     ["UPS Worldwide Expedited", 8682],
    #     ["UPS Saver", 9348],
    #     ["UPS Express", 9702],
    #     ["UPS Worldwide Express Plus", 14502]]

    # Check out USPS for comparison...
    usps = ActiveShipping::USPS.new(:login => ENV['ACTIVESHIPPING_USPS_LOGIN'])
    response = usps.find_rates(origin, destination, packages)

    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # => [["USPS Priority Mail International", 4110],
    #     ["USPS Express Mail International (EMS)", 5750],
    #     ["USPS Global Express Guaranteed Non-Document Non-Rectangular", 9400],
    #     ["USPS GXG Envelopes", 9400],
    #     ["USPS Global Express Guaranteed Non-Document Rectangular", 9400],
    #     ["USPS Global Express Guaranteed", 9400]]

  render json: usps_rates

  #
  # [
  #   ActiveShipping::Package.new( 100,                  # 100 grams
  #                                [93,10],              # 93 cm long, 10 cm diameter
  #                                :cylinder => true)
  #
  #   {
  #   "options":
  #     {"cylinder":true},
  #
  #   "dimensions":[
  #     {"amount":10,"unit":"centimetres"},
  #     {"amount":10,"unit":"centimetres"},
  #     {"amount":93,"unit":"centimetres"}
  #   ],
  #   "weight_unit_system":"metric",
  #   "dimensions_unit_system":"metric",
  #   "weight":{"amount":100,"unit":"grams"},
  #   "value":null,
  #   "currency":null,
  #   "cylinder":true,
  #   "gift":false,
  #   "oversized":false,
  #   "unpackaged":false},
  #
  #   {"options":{"units":"imperial"},"dimensions":[{"amount":4.5,"unit":"inches"},{"amount":10,"unit":"inches"},{"amount":15,"unit":"inches"}],"weight_unit_system":"imperial","dimensions_unit_system":"imperial","weight":{"amount":120.0,"unit":"ounces"},"value":null,"currency":null,"cylinder":false,"gift":false,"oversized":false,"unpackaged":false}]
  end

  def show
    render json: { ready_for_lunch: "yassss" }
  end
end
