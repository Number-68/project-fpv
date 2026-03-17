class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product




  def self.ransackable_attributes(auth_object = nil)
    ["id", "order_id", "product_id", "quantity", "unit_price", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end
end
