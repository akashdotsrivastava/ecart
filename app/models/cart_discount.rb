class CartDiscount < ApplicationRecord
  validates :total_basket_price, presence: true, numericality: { greater_than: 0 }
  validates :additional_discount, presence: true, numericality: { greater_than: 0 }
end
