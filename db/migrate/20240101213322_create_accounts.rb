class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :description
      t.belongs_to :workspace, index: true, foreign_key: true, null: false

      t.timestamps
    end
    add_index :accounts, :name
  end
end
