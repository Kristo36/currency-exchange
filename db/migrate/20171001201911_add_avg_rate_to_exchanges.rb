class AddAvgRateToExchanges < ActiveRecord::Migration[5.1]
  def change
    add_column :exchanges, :avg_rate, :decimal
  end
end
