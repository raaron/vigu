class SetDefaultNewsletterTrueBoughtbookFalse < ActiveRecord::Migration
  def change
    change_column_default(:users, :newsletter, true)
    change_column_default(:users, :bought_book, false)
  end
end
