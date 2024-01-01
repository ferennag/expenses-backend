class UpdateTransactionsBelongToAccounts < ActiveRecord::Migration[7.1]
  def change
    change_table :transactions do |t|
      t.belongs_to :account, foreign_key: true, null: false
    end
  end
end
