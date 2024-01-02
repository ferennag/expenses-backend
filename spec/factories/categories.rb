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
FactoryBot.define do
  sequence(:category_name) { |n| "Category #{n}" }

  factory :category do
    name { generate(:category_name) }
    parent {}
  end
end
