class ParagraphDateTimeToDate < ActiveRecord::Migration
  def change
    change_column :paragraphs, :for_date, :date
  end
end
