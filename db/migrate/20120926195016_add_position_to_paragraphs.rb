class AddPositionToParagraphs < ActiveRecord::Migration
  def change
    add_column :paragraphs, :position, :integer, :default => true

  end
end
