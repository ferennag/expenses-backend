class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.bigint :parent
      t.belongs_to :workspace, foreign_key: true, index: true, null: false

      t.timestamps
    end
    add_index :categories, :name
  end
end
