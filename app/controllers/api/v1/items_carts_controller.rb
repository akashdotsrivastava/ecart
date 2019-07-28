class Api::V1::ItemsCartsController < ApplicationController
  before_action :set_cart
  protect_from_forgery except: :create

  def index
    respond_to do |format|
      format.json {
        render json: @cart, serializer: Api::V1::CartItemsSerializer
      }
    end
  end

  def create
    @items_cart = @cart.items_carts.new(items_cat_params)
    respond_to do |format|
      if @items_cart.save
        format.json { render json: @items_cart, status: :created }
      else
        format.json { render json: @items_cart.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def items_cat_params
      params.require(:items_cart).permit(:item_id)
    end

    def set_cart
      @cart = Cart.find(params[:cart_id])
    end
end
