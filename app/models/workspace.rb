class Workspace < ApplicationRecord
  has_many :user_workspaces
  has_many :users, through: :user_workspaces
end
