require 'csv'

class TransactionsController < ApplicationController

  def import_transactions
    uploaded_file = params.require(:file)
    transactions = CsvImportService.new.import_file(uploaded_file.path)

    ActiveRecord::Base.transaction do
      transactions.each do |transaction|
        transaction.save!
      end
    end

    render json: {status: :success}
  rescue StandardError => error
    Rails.logger.error(error)
    render json: {status: :failure}
  end
end
