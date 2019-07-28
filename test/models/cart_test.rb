require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test 'cart_discount_when_no_cart_discount_applicable_configured' do
    cart = create(:cart)
    assert_equal cart.cart_discount_for(30.0), 0.0
  end

  test 'cart_discount_when_no_active_cart_discount_applicable_configured' do
    cart = create(:cart)
    create(:cart_discount, active: false)
    assert_equal cart.cart_discount_for(150.0), 0.0
  end

  test 'cart_discount_when_single_active_cart_discount_but_not_applicable_configured' do
    cart = create(:cart)
    create(:cart_discount, total_basket_price: 150.0, additional_discount: 20.0)
    assert_equal cart.cart_discount_for(130.0), 0.0
  end

  test 'cart_discount_when_single_active_cart_discount_applicable_configured' do
    cart = create(:cart)
    create(:cart_discount, total_basket_price: 150.0, additional_discount: 20.0)
    assert_equal cart.cart_discount_for(160.0), 20.0
  end

  test 'cart_discount_when_multiple_active_cart_discount_applicable_configured_with_varying_max_basket_price' do
    cart = create(:cart)
    create(:cart_discount, total_basket_price: 130.0, additional_discount: 20.0)
    create(:cart_discount, total_basket_price: 150.0, additional_discount: 25.0)
    assert_equal cart.cart_discount_for(160.0), 25.0
    assert_equal cart.cart_discount_for(149.0), 20.0
  end

  test 'cart_discount_when_multiple_active_cart_discount_applicable_configured_with_same_max_basket_price_different_discount' do
    cart = create(:cart)
    create(:cart_discount, total_basket_price: 130.0, additional_discount: 20.0)
    create(:cart_discount, total_basket_price: 130.0, additional_discount: 30.0)
    assert_equal cart.cart_discount_for(131.0), 30.0
  end

end
