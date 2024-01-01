require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  include ControllerSpecHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:workspace_id) { user.workspaces.first.id }
  let!(:headers) { stub_auth_headers(user.email) }

  context '/accounts' do
    describe 'happycase' do
      it 'returns all the accounts from the specific workspace' do
        get workspace_accounts_path(workspace_id), headers: headers
        expect(response.status).to eq(200)

        accounts = JSON.parse(response.body)
        expect(accounts.count).to eq(2)
      end
    end

    describe 'authorization' do
      let!(:other_user) { FactoryBot.create(:user) }
      let!(:other_workspace_id) { other_user.workspaces.first.id }

      it 'returns 403 when trying to access another user\'s accounts' do
        get workspace_accounts_path(other_workspace_id), headers: headers
        expect(response.status).to eq(403)
      end
    end
  end
end