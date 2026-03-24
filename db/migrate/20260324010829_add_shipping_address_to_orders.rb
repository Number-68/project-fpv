class AddShippingAddressToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :shipping_address_line1, :string
    add_column :orders, :shipping_address_line2, :string
    add_column :orders, :shipping_city, :string
    add_column :orders, :shipping_postal_code, :string
    add_column :orders, :shipping_province, :string
    remove_column :orders, :address, :string
  end
end
