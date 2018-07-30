namespace :letter do
  desc 'Finding letters, who older 3 months and changing to completed'
  task rails_task: :environment do
    letters = Letter.where('created_at < ?', 3.months.ago)
    letters = letters.map { |letter| letter.update(aasm_state: 'completed') if letter.aasm_state != 'completed'}
  end
end
