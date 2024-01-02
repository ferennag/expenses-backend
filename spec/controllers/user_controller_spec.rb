require 'rails_helper'

RSpec.describe UserController, type: :request do
  include ControllerSpecHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:headers) { stub_auth_headers(user.email) }

  describe 'profile' do
    context 'happycase' do
      before do
        get profile_path, headers: headers
        @body = JSON.parse(response.body)
      end

      it 'returns the user profile' do
        expect(response.status).to eq(200)
        expect(@body).to eq(JSON.parse(UserBlueprint.render(user, view: :full)))
      end

      it 'returns the user fields' do
        expect(@body['id']).to eq(user.id)
        expect(@body['email']).to eq(user.email)
      end

      it 'returns the workspace collection' do
        expect(@body['workspaces'].count).to eq(user.workspaces.count)
      end

      it 'returns the workspace associations' do
        workspace = Workspace.find(@body['workspaces'].first['id'])
        expect(@body['workspaces'].first.key? 'name').to eq(true)
        expect(@body['workspaces'].first.key? 'description').to eq(true)
        expect(@body['workspaces'].first.key? 'id').to eq(true)
        expect(@body['workspaces'].first['users'].count).to eq(workspace.users.count)
        expect(@body['workspaces'].first['accounts'].count).to eq(workspace.accounts.count)
        expect(@body['workspaces'].first['categories'].count).to eq(workspace.categories.count)
      end
    end
  end
end