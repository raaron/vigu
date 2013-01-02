class RemoveDefaultFromParagraphDate < ActiveRecord::Migration
  def change
    change_column :paragraphs, :date, :date
  end
end