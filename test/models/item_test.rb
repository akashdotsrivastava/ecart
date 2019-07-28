require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test 'discount_for_quantity_when_no_item_discounts_configured' do
    item = create(:item)
    assert_equal item.discount_for_quantity(3), 0.0
  end

  test 'discount_for_quantity_when_no_active_item_discounts_configured' do
    item = create(:item)
    create(:item_discount, item: item, active: false)
    assert_equal item.discount_for_quantity(3), 0.0
  end

  test 'discount_for_quantity_when_active_item_discounts_configured_but_not_applicable' do
    item = create(:item)
    create(:item_discount, item: item, quantity: 3)
    assert_equal item.discount_for_quantity(2), 0.0
  end

  test 'discount_for_quantity_when_single_active_item_discounts_configured' do
    item = create(:item)
    create(:item_discount, item: item, quantity: 3, discount: 25.0)
    assert_equal item.discount_for_quantity(3), 25.0
  end

  test 'discount_for_quantity_when_multiple_active_item_discounts_configured_with_varying_quantity' do
    item = create(:item)
    create(:item_discount, item: item, quantity: 3, discount: 25.0)
    create(:item_discount, item: item, quantity: 4, discount: 40.0)
    assert_equal item.discount_for_quantity(3), 25.0
    assert_equal item.discount_for_quantity(5), 40.0
  end

  test 'discount_for_quantity_when_multiple_active_item_discounts_configured_with_same_quantity_varying_discounts' do
    item = create(:item)
    create(:item_discount, item: item, quantity: 4, discount: 25.0)
    create(:item_discount, item: item, quantity: 4, discount: 40.0)
    assert_equal item.discount_for_quantity(5), 40.0
  end
end
