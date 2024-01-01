# == Schema Information
#
# Table name: workspaces
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Workspace < ApplicationRecord
  has_many :user_workspaces
  has_many :users, through: :user_workspaces
  has_many :accounts
end
