class Letter < ApplicationRecord
  include AASM
  YELLOW = 'rgba(169, 171, 48, 0.6)'
  GREEN = 'rgba(53, 114, 54, 0.6)'
  GRAY = 'rgba(0, 0, 0, 0.6)'
  RED = 'rgba(171, 48, 48, 0.6)'
  ASM_STATE_COLOR = { 'new' => YELLOW, 'running' => GREEN, 'sleeping' => GRAY, 'completed' => RED }
  VALID_EMAIL_REGEX = /\A[\-\+\w.]+@([a-z\d][-a-z\d]*\.)+[a-z]{2,4}\z/i
  before_save :save_email

  belongs_to :user

  validates :url_site, :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}

  scope :search_by_fields, ->(q_string) { where("email LIKE :q OR url_site LIKE :q", q: "%#{q_string}%") }
  scope :state_new, -> { where(aasm_state: 'new') }
  scope :state_running, -> { running }
  scope :state_sleeping, -> { sleeping }
  scope :state_completed, -> { completed }
  scope :expired_letters, -> { where('created_at < ? AND aasm_state != ?', 3.month.ago, 'completed') }

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
