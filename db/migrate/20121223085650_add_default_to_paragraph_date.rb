class AddDefaultToParagraphDate < ActiveRecord::Migration
  def change
    change_column :paragraphs, :date, :date, :default => Date.today
  end
end
