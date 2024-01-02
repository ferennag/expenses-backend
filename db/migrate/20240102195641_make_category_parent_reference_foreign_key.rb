class MakeCategoryParentReferenceForeignKey < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :categories, :categories, column: :parent
  end
end
