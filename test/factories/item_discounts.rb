FactoryBot.define do
  factory :item_discount do
    item
    quantity            { 3 }
    discount            { 20.0 }
    active              { true }
  end
end
