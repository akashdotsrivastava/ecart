class Api::V1::ItemDiscountsController < ApplicationController
  def index
    @item_discounts = ItemDiscount.active
    respond_to do |format|
      format.json {
        render json: @item_discounts
      }
    end
  end
end
