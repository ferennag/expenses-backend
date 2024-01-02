class ReferenceCategoriesFromTransactions < ActiveRecord::Migration[7.1]
  def change
    change_table :transactions do |t|
      t.belongs_to :category, foreign_key: true, index: true, null: true
    end
  end
end
