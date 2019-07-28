class Api::V1::ItemDiscountSerializer < ActiveModel::Serializer
  attributes :item_id, :quantity, :discount
end
