class CreateItemsCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :items_carts do |t|
      t.integer :item_id, null: false
      t.integer :cart_id, null: false
      t.timestamps
    end
  end
end
