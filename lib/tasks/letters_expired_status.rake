namespace :letter do
  desc 'Change the status of expired letters'
  task expired_letters_status_completed: :environment do
    Letter.expired_letters.update_all(aasm_state: 'completed')
  end
end
