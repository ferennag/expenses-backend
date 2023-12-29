require 'csv'

class TransactionsController < ApplicationController

  DEFAULT_PAGE_SIZE = 50
  DEFAULT_ORDER_BY = :date
  DEFAULT_ORDER = :desc

  def show
    # TODO move this piece of code into a concern/mixin to be reusable
    # TODO add validation of these parameters
    approved_params = params.permit(:page, :page_size, :order_by, :order)
    page = approved_params[:page] || 1
    page_size = approved_params[:page_size] || DEFAULT_PAGE_SIZE
    order_by = approved_params[:order_by] || DEFAULT_ORDER_BY
    order = approved_params[:order] || DEFAULT_ORDER
    # end

    render json: Transaction.order(order_by => order).page(page).per(page_size)
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
