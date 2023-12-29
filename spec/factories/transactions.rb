FactoryBot.define do
  factory :transaction do
    date { DateTime.parse('2023-07-21') }
    amount { '74.45' }
    memo { 'AMAZON.CA*260YB7BH3 AMAZON.CA' }
    reference { 'Reference: AT232030006000010430613' }
  end
end
