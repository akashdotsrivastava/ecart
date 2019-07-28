class Api::V1::CartItemsSerializer < ActiveModel::Serializer
  attributes :cart_items, :cart_price, :cart_discount, :amount_to_pay

  def cart_items
    items_cart_list.map{ |items_cart| Api::V1::CartItemSerializer.new(items_cart) }
  end

  def cart_price
    cart_items.map(&:final_price).sum
  end

  def cart_discount
    @object.cart_discount_for(cart_price)
  end

  def amount_to_pay
    cart_price - cart_discount
  end

  private

    def items_cart_list
      @object.items_carts.joins(:item).select(:item_id, 'items.name').group(:item_id).select('count(*) as quantity, sum(items.price) as total_price')
    end
end
