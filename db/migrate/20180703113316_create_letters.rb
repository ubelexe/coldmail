class CreateLetters < ActiveRecord::Migration[5.2]
  def change
    create_table :letters do |t|
      t.string :url_site
      t.string :email
      t.text :comment

      t.timestamps
    end
  end
end
