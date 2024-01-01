# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  has_many :user_workspaces
  has_many :workspaces, through: :user_workspaces

  after_create :create_default_workspace

  def create_default_workspace
    workspaces.create!(name: 'Default workspace')
  end

  def owns_workspace?(workspace_id)
    workspaces.pluck(:id).include?(workspace_id)
  end
end
