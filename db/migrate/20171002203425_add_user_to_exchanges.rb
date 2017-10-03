class AddUserToExchanges < ActiveRecord::Migration[5.1]
  def change
    add_reference :exchanges, :user, foreign_key: true
  end
end
