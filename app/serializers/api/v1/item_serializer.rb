class Api::V1::ItemSerializer < ActiveModel::Serializer
  attributes :name, :price
end
