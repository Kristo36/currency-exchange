class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.string :base
      t.string :target
      t.decimal :amount
      t.integer :weeks

      t.timestamps
    end
  end
end
