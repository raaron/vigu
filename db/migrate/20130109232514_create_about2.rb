class CreateAbout2 < ActiveRecord::Migration
  def up
    create_table(:about) do |t|
      t.column :contact_email_address, :string, :limit => 60
    end
    drop_table(:suppliers)
  end

  def down
  end
end
