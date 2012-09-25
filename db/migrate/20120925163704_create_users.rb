class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :street
      t.string :plz
      t.string :place
      t.string :country
      t.boolean :bought_book
      t.boolean :newsletter
      t.string :password_digest
      t.boolean :admin
      t.string :email

      t.timestamps
    end
  end
end
