require 'csv'

class TransactionsController < AccountBaseController
  include Pagination

  before_action :allow_pagination, only: [:index]

  def index
    load_account
    load_workspace

    transactions = policy_scope(Transaction)
    transactions = transactions.where(account_id: @account.id).where(account: { workspace_id: @workspace.id })
    transactions = transactions.order(@order_by => @order).page(@page).per(@page_size)
    render json: TransactionBlueprint.render(transactions)
  end

  def import_transactions
    load_workspace :update?
    load_account :update?

    authorize Transaction, :create?

    uploaded_file = params.require(:file)
    transactions = CsvImportService.new.import_file(uploaded_file.path)

    ActiveRecord::Base.transaction do
      transactions.each do |transaction|
        Transaction.find_or_create_by!(reference: transaction[:reference]) do |t|
          t.date = transaction[:date]
          t.amount = transaction[:amount]
          t.memo = transaction[:memo]
          t.account = @account
        end
      end
    end

    render json: { status: :success }
  rescue StandardError => error
    Rails.logger.error(error)
    render json: { status: :failure }
  end

  # TODO Transaction improvements needed:
  # - Allow creating, updating, and deleting transactions one by one
  # - Allow categorizing a single transaction
  # - Allow categorizing transactions in bulk
end
