class AddAasmStateToLetters < ActiveRecord::Migration[5.2]
  def change
    add_column :letters, :aasm_state, :string
  end
end
