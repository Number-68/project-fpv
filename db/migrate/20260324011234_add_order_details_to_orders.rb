class AddOrderDetailsToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :status, :string
    add_column :orders, :subtotal, :decimal
    add_column :orders, :gst, :decimal
    add_column :orders, :pst, :decimal
  end
end
