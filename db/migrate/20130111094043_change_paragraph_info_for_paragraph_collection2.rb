class ChangeParagraphInfoForParagraphCollection2 < ActiveRecord::Migration
  def up
    create_table :paragraph_collections do |t|
      t.integer :page_id
      t.string :section
      t.string :picture_mode
      t.boolean :has_caption
      t.boolean :has_date

      t.timestamps
    end
  end

  def down
  end
end
