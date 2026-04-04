class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items




  def self.ransackable_attributes(auth_object = nil)
    [ "id", "name", "brand", "description", "sku", "stock", "price", "category_id", "image_url", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "category", "order_items", "orders" ]
  end
end
