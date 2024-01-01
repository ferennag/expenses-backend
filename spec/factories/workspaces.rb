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
FactoryBot.define do
  factory :workspace do
    name { "MyString" }
    description { "MyString" }
  end
end
