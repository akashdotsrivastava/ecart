class Cart < ApplicationRecord
  has_many :items_carts

  def cart_discount_for(cart_price)
    # Add future sources for discount here and add to the result
    CartDiscount.active.applicable_for(cart_price).ordered_by_cart_price_and_discount.first&.additional_discount.to_f
  end
end
