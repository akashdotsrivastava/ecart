class Api::V1::CartsController < ApplicationController
  def index
    @carts = Cart.limit(1)
    respond_to do |format|
      format.json {
        render json: @carts
      }
    end
  end

  def create
    @cart = Cart.new()
    respond_to do |format|
      if @cart.save
        format.json { render json: @cart, status: :created }
      else
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end
end
