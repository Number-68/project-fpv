class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :brand
      t.text :description
      t.string :sku
      t.integer :stock
      t.decimal :price, precision: 10, scale: 2, null: false
      t.references :category, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
    add_index :products, :sku, unique: true
  end
end
