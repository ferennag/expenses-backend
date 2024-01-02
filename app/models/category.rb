# == Schema Information
#
# Table name: categories
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  parent       :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  workspace_id :bigint           not null
#
# Indexes
#
#  index_categories_on_name          (name)
#  index_categories_on_workspace_id  (workspace_id)
#
# Foreign Keys
#
#  fk_rails_...  (workspace_id => workspaces.id)
#
class Category < ApplicationRecord
  belongs_to :workspace
end
