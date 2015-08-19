FactoryGirl.define do
  factory :log do
    order_number 1
    provider "UPS"
    cost 155
    purchase_time Date.parse("August 19 2015")
  end
end
