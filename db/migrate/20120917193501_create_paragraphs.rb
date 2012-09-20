class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.string :section
      t.references :page

      t.timestamps
    end
    add_index :paragraphs, :page_id
  end
end
