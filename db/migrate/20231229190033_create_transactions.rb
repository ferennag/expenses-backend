class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.datetime :date
      t.string :reference
      t.string :memo
      t.string :amount

      t.timestamps
    end
    add_index :transactions, :date
    add_index :transactions, :reference
    add_index :transactions, :memo
  end
end
