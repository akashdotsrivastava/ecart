class ItemDiscount < ApplicationRecord
  belongs_to :item

  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than: 0 }
end
