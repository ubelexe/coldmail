class Letter < ApplicationRecord
  include AASM
  validates :url_site, :email, presence: true

  scope :search_by_fields, ->(q_string) { where("email LIKE :q OR url_site LIKE :q", q: "%#{q_string}%") }

  aasm do
    state :new, initial: true
    state :running, :sleeping, :completed

    event :run do
      transitions from: [:new, :sleeping], to: :running
    end

    event :done do
      transitions from: :running, to: :completed
    end

    event :sleep do
      transitions from: :running, to: :sleeping
    end
  end
end
