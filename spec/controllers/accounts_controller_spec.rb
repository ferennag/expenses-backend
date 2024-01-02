require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  include ControllerSpecHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:workspace_id) { user.workspaces.first.id }
  let!(:account_id) { user.workspaces.first.accounts.first.id }
  let!(:headers) { stub_auth_headers(user.email) }

  let!(:other_user) { FactoryBot.create(:user) }
  let!(:other_workspace_id) { other_user.workspaces.first.id }
  let!(:other_account_id) { other_user.workspaces.first.accounts.first.id }

  context 'index' do
    describe 'happycase' do
      it 'returns all the accounts from the specific workspace' do
        get workspace_accounts_path(workspace_id), headers: headers
        expect(response.status).to eq(200)

        accounts = JSON.parse(response.body)
        expect(accounts.count).to eq(2)
      end
    end

    describe 'authorization' do
      it 'returns 403 when trying to access another user\'s accounts' do
        get workspace_accounts_path(other_workspace_id), headers: headers
        expect(response.status).to eq(403)
      end
    end
  end

  context 'show' do
    describe 'happycase' do
      it 'returns the account' do
        get workspace_account_path(workspace_id, account_id), headers: headers
        expect(response.status).to eq(200)
        account = JSON.parse(response.body)

        expect(account.key? 'name').to be(true)
        expect(account.key? 'description').to be(true)
        expect(account.key? 'id').to be(true)
        expect(account['id']).to eq(account_id)
      end
    end

    describe 'authorization' do
      it 'returns 403 when trying to access another user\'s accounts' do
        get workspace_account_path(other_workspace_id, other_account_id), headers: headers
        expect(response.status).to eq(403)
      end
    end
  end

  context 'create' do
    describe 'happycase' do
      it 'creates a new account and returns it' do
        post workspace_accounts_path(workspace_id), params: { name: 'test', description: 'test dsc' }, headers: headers
        expect(response.status).to eq(200)
        account = JSON.parse(response.body)

        expect(account['name']).to eq('test')
        expect(account['description']).to eq('test dsc')
        expect(account.key? 'id').to be(true)
      end
    end

    describe 'authorization' do
      it 'returns 403 when trying to access another user\'s accounts' do
        post workspace_accounts_path(other_workspace_id), params: { name: 'test', description: 'test dsc' }, headers: headers
        expect(response.status).to eq(403)
      end
    end
  end

  context 'update' do
    describe 'happycase' do
      it 'creates a new account and returns it' do
        put workspace_account_path(workspace_id, account_id), params: { name: 'test', description: 'test dsc' }, headers: headers
        expect(response.status).to eq(200)
        account = JSON.parse(response.body)

        expect(account['name']).to eq('test')
        expect(account['description']).to eq('test dsc')
        expect(account.key? 'id').to be(true)
        expect(account['id']).to eq(account_id)
      end
    end

    describe 'authorization' do
      it 'returns 403 when trying to access another user\'s accounts' do
        put workspace_account_path(other_workspace_id, other_account_id), params: { name: 'test', description: 'test dsc' }, headers: headers
        expect(response.status).to eq(403)
      end
    end
  end
end