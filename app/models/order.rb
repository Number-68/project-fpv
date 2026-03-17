class Order < ApplicationRecord
  belongs_to :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items




  def self.ransackable_attributes(auth_object = nil)
    ["id", "customer_id", "order_date", "total_price", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["customer", "order_items", "products"]
  end
end
