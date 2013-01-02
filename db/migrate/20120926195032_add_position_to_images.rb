class AddPositionToImages < ActiveRecord::Migration
  def change
    add_column :images, :position, :integer, :default => true
  end
end
