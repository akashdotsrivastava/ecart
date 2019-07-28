class ItemsCart < ApplicationRecord
  belongs_to :item
  belongs_to :cart

  validates :item_id, presence: true
  validates :cart_id, presence: true
end
