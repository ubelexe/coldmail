class Letter < ApplicationRecord
  validates :url_site, :email, presence: true
end
