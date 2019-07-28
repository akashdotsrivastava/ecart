class CreateCartDiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_discounts do |t|
      t.float :total_basket_price, null: false
      t.float :additional_discount, null: false
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
