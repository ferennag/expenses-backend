# == Schema Information
#
# Table name: transactions
#
#  id          :bigint           not null, primary key
#  amount      :string
#  date        :datetime
#  memo        :string
#  reference   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#  category_id :bigint
#
# Indexes
#
#  index_transactions_on_account_id   (account_id)
#  index_transactions_on_category_id  (category_id)
#  index_transactions_on_date         (date)
#  index_transactions_on_memo         (memo)
#  index_transactions_on_reference    (reference)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (category_id => categories.id)
#
require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
