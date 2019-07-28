require 'test_helper'

class CompleteFlowTest < ActionDispatch::IntegrationTest
  setup do
    @item_a = create(:item, name: 'A', price: 30.0)
    @item_b = create(:item, name: 'B', price: 20.0)
    @item_c = create(:item, name: 'C', price: 50.0)
    @item_d = create(:item, name: 'D', price: 15.0)

    create(:item_discount, item: @item_a, quantity: 3, discount: 15.0)
    create(:item_discount, item: @item_b, quantity: 2, discount: 5.0)

    @cart1 = create(:cart)
    [@item_a, @item_b, @item_c].each do |item|
      create(:items_cart, cart: @cart1, item: item)
    end

    @cart2 = create(:cart)
    [@item_b, @item_a, @item_b, @item_a, @item_a].each do |item|
      create(:items_cart, cart: @cart2, item: item)
    end

    @cart3 = create(:cart)
    [@item_c, @item_b, @item_a, @item_a, @item_d, @item_a, @item_b].each do |item|
      create(:items_cart, cart: @cart3, item: item)
    end

    @cart4 = create(:cart)
    [@item_c, @item_a, @item_d, @item_a, @item_a].each do |item|
      create(:items_cart, cart: @cart4, item: item)
    end

    create(:cart_discount, total_basket_price: 150.0, additional_discount: 20.0)
  end

  test 'list items' do
    get api_v1_items_url, as: :json
    resp = JSON.parse(@response.body)

    assert_equal resp, [@item_a, @item_b, @item_c, @item_d].map { |item| { name: item.name, price: item.price }.stringify_keys }
  end

  test 'add items to cart' do
    new_cart = create(:cart)

    post api_v1_cart_items_carts_path(new_cart.id), params: { items_cart: { item_id: @item_a.id } }, as: :json
    resp = JSON.parse(@response.body)
    assert_equal resp['item_id'], @item_a.id
    assert_equal resp['cart_id'], new_cart.id
  end

  test 'list cart items with full prices and discount' do
    get api_v1_cart_items_carts_path(@cart1.id), as: :json
    resp = JSON.parse(@response.body)

    assert_equal resp, { cart_items: [{name: 'A', quantity: 1, total_price: 30.0, total_discount: 0.0, final_price: 30.0},
                                      {name: 'B', quantity: 1, total_price: 20.0, total_discount: 0.0, final_price: 20.0},
                                      {name: 'C', quantity: 1, total_price: 50.0, total_discount: 0.0, final_price: 50.0}],
                         cart_price: 100.0,
                         cart_discount: 0.0,
                         amount_to_pay: 100.0 }.deep_stringify_keys

    get api_v1_cart_items_carts_path(@cart2.id), as: :json
    resp = JSON.parse(@response.body)

    assert_equal resp, { cart_items: [{name: 'A', quantity: 3, total_price: 90.0, total_discount: 15.0, final_price: 75.0},
                                      {name: 'B', quantity: 2, total_price: 40.0, total_discount: 5.0, final_price: 35.0}],
                         cart_price: 110.0,
                         cart_discount: 0.0,
                         amount_to_pay: 110.0 }.deep_stringify_keys

    get api_v1_cart_items_carts_path(@cart3.id), as: :json
    resp = JSON.parse(@response.body)

    assert_equal resp, { cart_items: [{name: 'A', quantity: 3, total_price: 90.0, total_discount: 15.0, final_price: 75.0},
                                      {name: 'B', quantity: 2, total_price: 40.0, total_discount: 5.0, final_price: 35.0},
                                      {name: 'C', quantity: 1, total_price: 50.0, total_discount: 0.0, final_price: 50.0},
                                      {name: 'D', quantity: 1, total_price: 15.0, total_discount: 0.0, final_price: 15.0}],
                         cart_price: 175.0,
                         cart_discount: 20.0,
                         amount_to_pay: 155.0 }.deep_stringify_keys

    get api_v1_cart_items_carts_path(@cart4.id), as: :json
    resp = JSON.parse(@response.body)

    assert_equal resp, { cart_items: [{name: 'A', quantity: 3, total_price: 90.0, total_discount: 15.0, final_price: 75.0},
                                      {name: 'C', quantity: 1, total_price: 50.0, total_discount: 0.0, final_price: 50.0},
                                      {name: 'D', quantity: 1, total_price: 15.0, total_discount: 0.0, final_price: 15.0}],
                         cart_price: 140.0,
                         cart_discount: 0.0,
                         amount_to_pay: 140.0 }.deep_stringify_keys
  end
end