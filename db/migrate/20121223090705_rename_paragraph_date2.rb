class RenameParagraphDate2 < ActiveRecord::Migration
  def change
    rename_column(:paragraphs, :birthday, :for_date)
  end
end
