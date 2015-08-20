class LogsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    create_log
    render json: {"SUCCESS": "YAY"}
  end

  private

  def create_log
    Log.create(
      client_name: params[:id],
      order_number: params["order_number"],
      provider: params["provider"],
      cost: params["cost"],
      estimate: params["estimate"],
      purchase_time: params["purchase_time"]
    )
  end
end
