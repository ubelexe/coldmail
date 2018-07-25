ActiveAdmin.register Letter do
  permit_params :url_site, :email, :comment, :created_at, :updated_at
  scope :state_new
end
