class RenameParagraphDate3 < ActiveRecord::Migration
  def change
    rename_column(:paragraphs, :for_date, :date)
  end
end
