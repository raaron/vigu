class CreateAbout < ActiveRecord::Migration
  def up
    create_table(:suppliers) do |t|
      t.column :contact_email_address, :string, :limit => 60
    end
  end

  def down
  end
end
