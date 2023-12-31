# == Schema Information
#
# Table name: user_workspaces
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#  workspace_id :bigint           not null
#
# Indexes
#
#  index_user_workspaces_on_user_id       (user_id)
#  index_user_workspaces_on_workspace_id  (workspace_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (workspace_id => workspaces.id)
#
class UserWorkspace < ApplicationRecord
  belongs_to :workspace
  belongs_to :user
end
