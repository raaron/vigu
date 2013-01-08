class CreateParagraphCollections < ActiveRecord::Migration
  def change
    create_table :paragraph_collections do |t|
      t.integer :page_id
      t.string :section

      t.timestamps
    end
  end
end
