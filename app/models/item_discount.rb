class ItemDiscount < ApplicationRecord
  belongs_to :item

  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
  scope :for_item_id, lambda { |item_id| where(item_id: item_id) }
  scope :for_quantity, lambda { |quantity| where('quantity <= ?', quantity) }
  scope :ordered_by_quantity_and_discount, -> { order(quantity: :desc, discount: :desc) }

  def self.applicable_for(item_id, item_quantity)
    discounts_available = ItemDiscount.active.for_item_id(item_id)
    return 0 unless discounts_available.count.positive?
    applicable_discount(discounts_available, item_quantity)
  end

  private

    def self.applicable_discount(discounts_available, item_quantity)
      return 0 if item_quantity < discounts_available.minimum(:quantity)
      applicable_discount_record = discounts_available.for_quantity(item_quantity).ordered_by_quantity_and_discount.first
      (item_quantity / applicable_discount_record.quantity) * applicable_discount_record.discount
    end

end
