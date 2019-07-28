class Api::V1::CartItemSerializer < ActiveModel::Serializer
  attributes :name, :quantity, :total_price, :total_discount, :final_price

  def total_discount
    item.discount_for_quantity(@object.quantity)
  end

  def final_price
    @object.total_price - total_discount
  end

  private

    def item
      Item.find(@object.item_id)
    end
end
