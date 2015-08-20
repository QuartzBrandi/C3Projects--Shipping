class LogsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    log = create_log
    if log.save
      render json: log, status: 201
    else
      render nothing: true, status: 400
    end
  end

  private

  def create_log
    Log.new(
      client_name: params[:id],
      order_number: params["order_number"],
      provider: params["provider"],
      cost: params["cost"],
      estimate: params["estimate"],
      purchase_time: params["purchase_time"]
    )
  end
end
