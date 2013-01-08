class RemoveColumnSectionFromParagraphs < ActiveRecord::Migration
  def up
    remove_column("paragraphs", "section")
  end

  def down
  end
end
