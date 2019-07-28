require 'test_helper'

class Api::V1::ItemsControllerTest < ActionController::TestCase
  test 'index' do
    item_a = create(:item, name: 'A', price: 30.0)
    item_b = create(:item, name: 'B', price: 20.0)
    item_c = create(:item, name: 'C', price: 50.0)
    item_d = create(:item, name: 'D', price: 15.0)

    get :index, format: :json
    resp = JSON.parse(@response.body)
    assert resp.is_a? Array
  end
end
