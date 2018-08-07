class AddUserIdToLetters < ActiveRecord::Migration[5.1]
  def change
    add_reference :letters, :user, foreign_key: true
  end
end
