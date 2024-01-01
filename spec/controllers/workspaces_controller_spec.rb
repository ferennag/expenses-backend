require 'rails_helper'

RSpec.describe WorkspacesController, type: :request do
  include ControllerSpecHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:headers) { stub_auth_headers(user.email) }

  describe '/workspaces' do
    context 'happycase' do
      it 'returns all of the user\'s workspaces' do
        get workspaces_path, headers: headers
        expect(response.status).to eq(200)
      end
    end
  end

  describe '/workspaces/<id>' do
    context 'happycase' do
      it 'returns all of the user\'s workspaces' do
        get workspace_path(user.workspaces.first.id), headers: headers
        expect(response.status).to eq(200)
      end
    end

    context 'wrong id' do
      it 'returns 404 response' do
        get workspace_path(123), headers: headers
        expect(response.status).to eq(404)
      end
    end

    context 'trying to get another user\'s workspace' do
      let!(:other_user) { FactoryBot.create(:user, email: 'other-user@example.com') }

      it 'returns 404 response' do
        # user's own workspace
        get workspace_path(user.workspaces.first.id), headers: headers
        expect(response.status).to eq(200)

        # another user's workspace, I shouldn't be able to see it
        get workspace_path(other_user.workspaces.first.id), headers: headers
        expect(response.status).to eq(404)
      end
    end
  end
end
