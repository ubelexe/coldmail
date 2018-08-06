class CreateLetters < ActiveRecord::Migration[5.1]
  def change
    create_table :letters do |t|
      t.string :url_site
      t.string :email, index: true
      t.text :comment

      t.timestamps
    end
  end
end
