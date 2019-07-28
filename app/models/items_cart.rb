class ItemsCart < ApplicationRecord
  belongs_to :item
  belongs_to :cart

  validates :item_id, presence: true
  validates :cart_id, presence: true

  validates :item_id, uniqueness: { scope: :cart_id }
end
