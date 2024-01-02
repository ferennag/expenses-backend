require 'csv'

class TransactionsController < ApplicationController
  include Pagination

  before_action :allow_pagination, only: [:index]

  def index
    workspace_id = params.require(:workspace_id)
    account_id = params.require(:account_id)
    transactions = policy_scope(Transaction)
    transactions = transactions.where(account_id: account_id).where(account: { workspace_id: workspace_id })
    transactions = transactions.order(@order_by => @order).page(@page).per(@page_size)
    render json: TransactionBlueprint.render(transactions)
  end

  def import_transactions
    workspace_id = params.require(:workspace_id)
    workspace = Workspace.find(workspace_id)
    account_id = params.require(:account_id)
    account = Account.find(account_id)

    authorize workspace, :update?
    authorize account, :update?
    authorize Transaction, :create?

    uploaded_file = params.require(:file)
    transactions = CsvImportService.new.import_file(uploaded_file.path)

    ActiveRecord::Base.transaction do
      transactions.each do |transaction|
        Transaction.find_or_create_by!(reference: transaction[:reference]) do |t|
          t.date = transaction[:date]
          t.amount = transaction[:amount]
          t.memo = transaction[:memo]
          t.account = account
        end
      end
    end

    render json: { status: :success }
  rescue StandardError => error
    Rails.logger.error(error)
    render json: { status: :failure }
  end
end
