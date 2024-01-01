class UpdateForeignKeys < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :user_workspaces, :users
    add_foreign_key :user_workspaces, :workspaces

    change_column_null :user_workspaces, :user_id, false
    change_column_null :user_workspaces, :workspace_id, false
  end
end
