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
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'default workspace' do
    it 'creates a default workspace for each new user' do
      user = User.create!(email: 'test@test.com', password_digest: 'pass1234')
      expect(user).to be_present
      expect(user.workspaces.count).to eq(1)
      expect(user.workspaces.first.name).to eq('Default workspace')

      workspaces = Workspace.joins(:users).where(users: user)
      expect(user.workspaces.first).to eq(workspaces.first)
    end
  end
end
