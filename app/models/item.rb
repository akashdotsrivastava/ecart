class Item < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true, numericality: true

  has_many :item_discounts

  def discount_for_quantity(quantity)
    # Add future sources for discount here and add to the result
    ItemDiscount.applicable_for(self.id, quantity)
  end
end
