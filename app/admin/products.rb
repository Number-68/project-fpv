ActiveAdmin.register Product do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :brand, :description, :sku, :stock, :price, :category_id, :image_url
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :brand, :description, :sku, :stock, :price, :category_id, :image_url]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :category_id, :name, :brand, :description, :sku, :stock, :price, :image_url
end
