require 'rails_helper'

RSpec.describe TransactionsController, type: :request do
  describe '/transactions/import' do
    let(:filename) { 'valid.csv' }
    let!(:file) { fixture_file_upload(filename) }

    context 'happycase' do
      it 'imports the file successfully' do
        expect(Transaction.count).to eq(0)

        post import_transactions_path, params: { file: file }
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("success")

        expect(Transaction.count).to eq(3)
      end
    end

    context 'duplicate transactions are filtered based on reference' do
      before do
        FactoryBot.create(:transaction, reference: "Reference: AT232030006000010464975")
        FactoryBot.create(:transaction, reference: "Reference: AT232030006000010410850")
      end

      it 'doesnt duplicate transactions' do
        expect(Transaction.count).to eq(2)

        post import_transactions_path, params: { file: file }
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("success")

        expect(Transaction.count).to eq(3)
      end
    end

    context 'no file provided' do
      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post import_transactions_path
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end

    context 'empty file provided' do
      let(:filename) { 'empty.csv' }

      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post import_transactions_path, params: { file: file }
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end

    context 'invalid file provided' do
      let(:filename) { 'invalid.csv' }

      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post import_transactions_path, params: { file: file }
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end

    context 'incorrect parameter name' do
      it 'returns an error response' do
        expect(Transaction.count).to eq(0)

        post import_transactions_path, params: { incorrect_name: file }
        body = JSON.parse(response.body)
        expect(body["status"]).to eq("failure")

        expect(Transaction.count).to eq(0)
      end
    end
  end
end