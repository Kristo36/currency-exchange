class CreateCurrencyQuotes < ActiveRecord::Migration[5.1]
  def change
    create_table :currency_quotes do |t|
      t.string :base
      t.string :target
      t.date :date
      t.decimal :rate

      t.timestamps
    end
  end
end
