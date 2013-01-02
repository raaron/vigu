class RenameParagraphDate < ActiveRecord::Migration
  def change
    rename_column(:paragraphs, :date, :birthday)
  end
end
