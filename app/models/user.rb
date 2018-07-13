class User < ApplicationRecord
  has_many :letters
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
