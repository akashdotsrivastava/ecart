FactoryBot.define do
  factory :cart_discount do
    total_basket_price  { 150.0 }
    additional_discount { 20.0 }
    active              { true }
  end
end
