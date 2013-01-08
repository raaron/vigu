class RenamePageIdToParagraphCollectionId < ActiveRecord::Migration
  def up
    rename_column("paragraphs", "page_id", "paragraph_collection_id")
  end

  def down
  end
end
