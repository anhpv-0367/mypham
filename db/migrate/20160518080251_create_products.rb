class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.float :pre_price
      t.float :price
      t.string :category
      t.boolean :special

      t.timestamps null: false
    end
  end
end
