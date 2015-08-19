class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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

end
