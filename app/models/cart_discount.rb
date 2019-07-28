class CartDiscount < ApplicationRecord
  validates :total_basket_price, presence: true, numericality: { greater_than: 0 }
  validates :additional_discount, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
  scope :applicable_for, lambda { |cart_price| where('total_basket_price <= ?', cart_price) }
  scope :ordered_by_cart_price_and_discount, -> { order(total_basket_price: :desc, additional_discount: :desc) }
end
