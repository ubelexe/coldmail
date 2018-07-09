class Letter < ApplicationRecord
  validates :url_site, :email, presence: true

  scope :search_by_fields, ->(q_string) { where("email LIKE :q OR url_site LIKE :q", q: "%#{q_string}%") }
end
