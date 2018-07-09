class Letter < ApplicationRecord
  include AASM
  validates :url_site, :email, presence: true

  aasm do
    state :new, :initial => true
    state :running, :sleeping, :completed

    event :run do
      transitions :from => [:new, :sleeping], :to => :running
    end

    event :done do
      transitions :from => :running, :to => :completed
    end

    event :sleep do
      transitions :from => :running, :to => :sleeping
    end
  end

end
