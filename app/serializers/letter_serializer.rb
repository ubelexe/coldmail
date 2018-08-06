class LetterSerializer < ActiveModel::Serializer
  attributes :url_site, :email, :comment, :aasm_state, :created_at
  belongs_to :user
end
