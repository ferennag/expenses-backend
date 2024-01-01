# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  description  :string
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  workspace_id :bigint           not null
#
# Indexes
#
#  index_accounts_on_name          (name)
#  index_accounts_on_workspace_id  (workspace_id)
#
# Foreign Keys
#
#  fk_rails_...  (workspace_id => workspaces.id)
#
FactoryBot.define do
  sequence(:account_name) { |n| "Demo Account #{n}" }
  sequence(:account_description) { |n| "Demo Account #{n} description" }

  factory :account do
    name { generate(:account_name) }
    description { generate(:account_description) }
  end
end
