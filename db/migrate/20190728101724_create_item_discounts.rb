class CreateItemDiscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :item_discounts do |t|
      t.integer :item_id, null: false
      t.integer :quantity, null: false
      t.float :discount, null: false
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
