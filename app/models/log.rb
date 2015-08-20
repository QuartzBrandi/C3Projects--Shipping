class Log < ActiveRecord::Base
  # Validation------------------------------------------------------------------
  validates :order_number, :provider, :cost, :purchase_time, :client_name, presence: :true
  validates :order_number, :cost, numericality: { only_integer: true }
end
