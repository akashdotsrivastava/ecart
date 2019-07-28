class Api::V1::ItemsController < ApplicationController
  def index
    @items = Item.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.json {
        render json: @items
      }
    end
  end
end
