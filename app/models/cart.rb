class Cart < ApplicationRecord
  has_many :items_carts

  def cart_discount_for(cart_price)
    CartDiscount.active.applicable_for(cart_price).ordered_by_cart_price_and_discount.first&.additional_discount.to_i
  end
end
