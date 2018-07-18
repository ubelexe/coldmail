class Letter < ApplicationRecord
  include AASM
  before_save :save_email

  belongs_to :user

  validates :url_site, :email, presence: true
  VALID_EMAIL_REGEX = /\A[\-\+\w.]+@([a-z\d][-a-z\d]*\.)+[a-z]{2,4}\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

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

  def save_email
    self.email = email.downcase
  end
end
