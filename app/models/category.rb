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
#  fk_rails_...  (parent => categories.id)
#  fk_rails_...  (workspace_id => workspaces.id)
#
class Category < ApplicationRecord
  belongs_to :workspace

  validates :name, presence: true
  validate :parent_in_same_workspace

  protected

  def parent_in_same_workspace
    return true unless parent.present?

    p = Category.where(workspace: workspace, id: parent).limit(1)
    unless p.present? && p.count == 1 && p[0].id == parent
      errors.add(:parent, 'parent must exist in the same workspace')
    end
  end
end
