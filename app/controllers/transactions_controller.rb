require 'csv'

class TransactionsController < ApplicationController
  include Pagination

  before_action :allow_pagination, only: [:show]

  def show
    render json: Transaction.order(@order_by => @order).page(@page).per(@page_size)
  end

  def import_transactions
    uploaded_file = params.require(:file)
    transactions = CsvImportService.new.import_file(uploaded_file.path)

    ActiveRecord::Base.transaction do
      transactions.each do |transaction|
        Transaction.find_or_create_by!(reference: transaction[:reference]) do |t|
          t.date = transaction[:date]
          t.amount = transaction[:amount]
          t.memo = transaction[:memo]
        end
      end
    end

    render json: {status: :success}
  rescue StandardError => error
    Rails.logger.error(error)
    render json: {status: :failure}
  end
end
