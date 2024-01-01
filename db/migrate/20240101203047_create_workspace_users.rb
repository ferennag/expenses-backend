class CreateWorkspaceUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :user_workspaces do |t|
      t.belongs_to :user
      t.belongs_to :workspace

      t.timestamps
    end
  end
end
