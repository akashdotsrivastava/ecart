require 'test_helper'

class Api::V1::ItemsCartsControllerTest < ActionController::TestCase
  test 'create' do
    cart = create(:cart)
    item = create(:item)
    assert_difference('ItemsCart.count', 1) do
      post :create, params: { cart_id: cart.id, items_cart: { item_id: item.id } }, format: :json
      assert_response :success
    end
  end

  test 'index' do
    item_a = create(:item, name: 'A', price: 30.0)
    item_b = create(:item, name: 'B', price: 20.0)
    item_c = create(:item, name: 'C', price: 50.0)
    item_d = create(:item, name: 'D', price: 15.0)

    cart1 = create(:cart)

    create(:items_cart, item: item_a, cart: cart1)
    create(:items_cart, item: item_b, cart: cart1)
    create(:items_cart, item: item_c, cart: cart1)

    get :index, params: { cart_id: 1 }, format: :json
    assert_response :success

    resp = JSON.parse(@response.body)
    assert_equal resp.keys.sort, %w[cart_items cart_price cart_discount amount_to_pay].sort
    assert resp['cart_items'].is_a? Array    
  end
end
