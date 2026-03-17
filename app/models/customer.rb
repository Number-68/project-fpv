class Customer < ApplicationRecord
    has_secure_password
    has_many :orders

    def self.ransackable_attributes(auth_object = nil)
        ["id", "first_name", "last_name", "email", "phone_number", "address", "password", "created_at", "updated_at"]
    end


    def self.ransackable_associations(auth_object = nil)
        ["orders"]
    end

    
end
