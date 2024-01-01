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
class Account < ApplicationRecord
  belongs_to :workspace

  has_many :transactions
end
