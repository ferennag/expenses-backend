class User < ApplicationRecord
  has_secure_password

  has_many :user_workspaces
  has_many :workspaces, through: :user_workspaces

  after_create :create_default_workspace

  def create_default_workspace
    workspaces.create!(name: 'Default workspace')
  end
end
