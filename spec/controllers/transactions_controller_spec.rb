require 'rails_helper'

RSpec.describe TransactionsController, type: :request do
  include ControllerSpecHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:workspace_id) { user.workspaces.first.id }
  let!(:account_id) { user.workspaces.first.accounts.first.id }
  let!(:headers) { stub_auth_headers(user.email) }

  describe '/transactions' do
    context 'happycase' do
      before do
        FactoryBot.create(:transaction, reference: "Reference: AT232030006000010464975", account_id: account_id)
        FactoryBot.create(:transaction, reference: "Reference: AT232030006000010410850", account_id: account_id)
        FactoryBot.create(:transaction, reference: "Reference: AT232030006000010410850", account_id: account_id)
      end

      it 'returns all transactions' do
        get workspace_account_transactions_path(workspace_id, account_id), headers: headers
        body = JSON.parse(response.body)
        expect(body.count).to eq(3)

        body.each do |item|
          expect(item.key? 'amount').to be_truthy
          expect(item.key? 'date').to be_truthy
          expect(item.key? 'memo').to be_truthy
          expect(item.key? 'reference').to be_truthy
        end
      end

      it 'accepts pagination parameters' do
        get workspace_account_transactions_path(workspace_id, account_id), params: { page: 1, page_size: 25, order_by: 'id', order: 'desc' }, headers: headers
        body = JSON.parse(response.body)
        expect(body.count).to eq(3)
      end

      it 'returns 0 results for the last page' do
        get workspace_account_transactions_path(workspace_id, account_id), params: { page: 2, page_size: 25, order_by: 'id', order: 'desc' }, headers: headers
        body = JSON.parse(response.body)
        expect(body.count).to eq(0)
      end

      it 'restricts the result size according to the page_size' do
        get workspace_account_transactions_path(workspace_id, account_id), params: { page: 1, page_size: 2, order_by: 'id', order: 'asc' }, headers: headers
        body = JSON.parse(response.body)
        expect(body.count).to eq(2)
      end
    end
  end

  describe '/transactions/import' do
    let(:filename) { 'valid.csv' }
    let!(:file) { fixture_file_upload(filename) }

    context 'happycase' do
      it 'imports the file successfully' do
        expect(Transaction.count).to eq(0)

        post workspace_account_transactions_import_path(workspace_id, account_id), params: { file: file }, headers: headers
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("success")

        expect(Transaction.count).to eq(3)
      end
    end

    context 'duplicate transactions are filtered based on reference' do
      before do
        FactoryBot.create(:transaction, reference: "Reference: AT232030006000010464975", account_id: account_id)
        FactoryBot.create(:transaction, reference: "Reference: AT232030006000010410850", account_id: account_id)
      end

      it 'doesnt duplicate transactions' do
        expect(Transaction.count).to eq(2)

        post workspace_account_transactions_import_path(workspace_id, account_id), params: { file: file }, headers: headers
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("success")

        expect(Transaction.count).to eq(3)
      end
    end

    context 'no file provided' do
      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post workspace_account_transactions_import_path(workspace_id, account_id), headers: headers
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end

    context 'empty file provided' do
      let(:filename) { 'empty.csv' }

      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post workspace_account_transactions_import_path(workspace_id, account_id), params: { file: file }, headers: headers
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end

    context 'invalid file provided' do
      let(:filename) { 'invalid.csv' }

      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post workspace_account_transactions_import_path(workspace_id, account_id), params: { file: file }, headers: headers
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end

    context 'incorrect parameter name' do
      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post workspace_account_transactions_import_path(workspace_id, account_id), params: { incorrect_name: file }, headers: headers
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end

    context 'trying to import into someone else account/workspace' do
      let!(:other_user) { FactoryBot.create(:user) }
      let!(:other_workspace_id) { other_user.workspaces.first.id }
      let!(:other_account_id) { other_user.workspaces.first.accounts.first.id }

      it 'returns an error response for wrong workspace id' do
        expect(Transaction.count).to eq(0)

        post workspace_account_transactions_import_path(other_workspace_id, account_id), params: { file: file }, headers: headers
        body = JSON.parse(response.body)
        # expect(response.status).to eq(403)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end

      it 'returns an error response for wrong account id' do
        expect(Transaction.count).to eq(0)

        post workspace_account_transactions_import_path(workspace_id, other_account_id), params: { file: file }, headers: headers
        body = JSON.parse(response.body)
        # expect(response.status).to eq(403)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end
  end
end