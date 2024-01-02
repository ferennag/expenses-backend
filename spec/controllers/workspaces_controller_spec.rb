require 'rails_helper'

RSpec.describe WorkspacesController, type: :request do
  include ControllerSpecHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:headers) { stub_auth_headers(user.email) }

  describe 'index' do
    context 'happycase' do
      it 'returns all of the user\'s workspaces' do
        get workspaces_path, headers: headers
        expect(response.status).to eq(200)
        body = response.body
        expect(body).to eq(WorkspaceBlueprint.render(user.workspaces))
      end
    end
  end

  describe 'create' do
    before do
      post workspaces_path, headers: headers, params: post_body
      begin
        @body = JSON.parse(response.body)
      rescue JSON::ParserError
        # Ignored
      end
    end

    context 'happycase' do
      let!(:post_body) { { name: 'test', description: 'test dsc' } }

      it 'creates a workspace and returns it in the response' do
        expect(response.status).to eq(200)
        expect(@body['name']).to eq(post_body[:name])
        expect(@body['description']).to eq(post_body[:description])
        expect(@body.key? 'id').to eq(true)
      end
    end

    context 'can create a workspace without a description' do
      let!(:post_body) { { name: 'test' } }

      it 'creates the workspace without a description' do
        expect(@body['name']).to eq(post_body[:name])
        expect(@body['description']).to be_nil
        expect(@body.key? 'id').to eq(true)
      end
    end

    context 'cannot create a workspace without a name' do
      let!(:post_body) { { description: 'test' } }

      it 'throws a HTTP 422 unprocessable entity error' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'update' do
    let!(:workspace) { user.workspaces.first }

    before do
      put workspace_path(workspace.id), headers: headers, params: post_body
      begin
        @body = JSON.parse(response.body)
      rescue JSON::ParserError
        # Ignored
      end
    end

    context 'happycase' do
      let!(:post_body) { { name: 'test', description: 'test dsc' } }

      it 'updates a workspace and returns it in the response' do
        expect(response.status).to eq(200)
        expect(@body['name']).to eq(post_body[:name])
        expect(@body['description']).to eq(post_body[:description])
        workspace.reload
        expect(@body['id']).to eq(workspace.id)
      end
    end
  end

  describe 'show' do
    context 'happycase' do
      it 'returns all of the user\'s workspaces' do
        get workspace_path(user.workspaces.first.id), headers: headers
        expect(response.status).to eq(200)
        expect(body).to eq(WorkspaceBlueprint.render(user.workspaces.first))
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

      it 'returns 403 response' do
        # user's own workspace
        get workspace_path(user.workspaces.first.id), headers: headers
        expect(response.status).to eq(200)

        # another user's workspace, I shouldn't be able to see it
        get workspace_path(other_user.workspaces.first.id), headers: headers
        expect(response.status).to eq(403)
      end
    end
  end
end
