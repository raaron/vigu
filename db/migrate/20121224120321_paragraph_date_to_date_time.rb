class ParagraphDateToDateTime < ActiveRecord::Migration
  def change
    change_column :paragraphs, :for_date, :datetime
  end
end
