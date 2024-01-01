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
FactoryBot.define do
  sequence(:user_email) { |n| "user#{n}@example.com" }

  factory :user do
    email { generate(:user_email) }
    password { "admin1234" }
    password_confirmation { "admin1234" }

    after :create do |user|
      create_list :account, 2, workspace: user.workspaces.first
    end
  end
end
