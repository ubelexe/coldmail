ActiveAdmin.register Letter do
  permit_params :url_site, :email, :comment, :created_at, :updated_at
  scope :state_new
  scope :state_running
  scope :state_sleeping
  scope :state_completed
end
