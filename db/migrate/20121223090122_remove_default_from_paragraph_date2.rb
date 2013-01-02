class RemoveDefaultFromParagraphDate2 < ActiveRecord::Migration
  def change
  change_column_default(:paragraphs, :date, nil)
end
end
