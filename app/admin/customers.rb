ActiveAdmin.register Customer do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :first_name, :last_name, :email, :password_digest, :phone_number, :address
  #
  # or
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email, :password_digest, :phone_number, :address]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :first_name, :last_name, :email, :phone_number, :address, :password, :password_confirmation

  filter :id
  filter :first_name
  filter :last_name
  filter :email
  filter :phone_number
  filter :address
  filter :created_at
  filter :updated_at
end
