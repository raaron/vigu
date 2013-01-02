class AddDateToParagraphs < ActiveRecord::Migration
  def change
    add_column :paragraphs, :date, :date
  end
end
