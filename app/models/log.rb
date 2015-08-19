class Log < ActiveRecord::Base
  # Validation------------------------------------------------------------------
  validates :order_number, :provider, :cost, :purchase_time, presence: :true
end
