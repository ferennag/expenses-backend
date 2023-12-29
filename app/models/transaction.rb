class Transaction < ApplicationRecord
  paginates_per 50
  max_paginates_per 200
end
