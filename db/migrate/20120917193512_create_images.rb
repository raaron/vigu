class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :caption
      t.references :paragraph

      t.timestamps
    end
    add_index :images, :paragraph_id
  end
end
