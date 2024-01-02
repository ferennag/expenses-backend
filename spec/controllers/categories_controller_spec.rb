require 'rails_helper'

RSpec.describe CategoriesController, type: :request do
  include ControllerSpecHelpers

  let!(:user) { FactoryBot.create(:user) }
  let!(:workspace_id) { user.workspaces.first.id }
  let!(:account_id) { user.workspaces.first.accounts.first.id }
  let!(:headers) { stub_auth_headers(user.email) }

  let!(:url) { "" }

  describe 'index' do
    let!(:url) { workspace_categories_path(workspace_id) }

    before do
      get url, headers: headers
      begin
        @body = JSON.parse(response.body)
      rescue
        # ignored
      end
    end

    context 'happycase' do
      it 'returns the list of categories' do
        expect(response.status).to eq(200)
        expect(@body.count).to eq(2)
        expect(@body[0].key? 'id').to eq(true)
        expect(@body[0].key? 'name').to eq(true)
        expect(@body[0].key? 'parent').to eq(true)
      end
    end

    context 'authorization' do
      let!(:other_user) { FactoryBot.create(:user) }
      let!(:workspace_id) { other_user.workspaces.first.id }

      it 'returns error 403 for trying to access another users categories' do
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'show' do
    let!(:category) { user.workspaces.first.categories.first }
    let!(:url) { workspace_category_path(workspace_id, category.id) }

    before do
      get url, headers: headers
      begin
        @body = JSON.parse(response.body)
      rescue
        # ignored
      end
    end

    context 'happycase' do
      it 'returns the category' do
        expect(response.status).to eq(200)
        expect(@body).to eq(JSON.parse(CategoryBlueprint.render(category)))
        expect(@body.key? 'id').to eq(true)
        expect(@body.key? 'name').to eq(true)
        expect(@body.key? 'parent').to eq(true)
      end
    end

    context 'authorization' do
      let!(:other_user) { FactoryBot.create(:user) }
      let!(:workspace_id) { other_user.workspaces.first.id }
      let!(:category) { other_user.workspaces.first.categories.first }

      it 'returns error 403 for trying to access another users categories' do
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'create' do
    let!(:url) { workspace_categories_path(workspace_id) }
    let!(:params) { { name: 'Test' } }

    before do
      post url, headers: headers, params: params
      begin
        @body = JSON.parse(response.body)
      rescue
        # ignored
      end
    end

    context 'happycase' do
      it 'returns the category' do
        expect(response.status).to eq(200)
        expect(@body.key? 'id').to eq(true)
        expect(@body['name']).to eq(params[:name])
        expect(@body['parent']).to be_nil
      end
    end

    context 'with parent category' do
      let!(:parent) { user.workspaces.first.categories.first }
      let!(:params) { { name: 'Test', parent: parent.id } }

      it 'creates the category linking it to the parent' do
        expect(response.status).to eq(200)
        expect(@body.key? 'id').to eq(true)
        expect(@body['name']).to eq(params[:name])
        expect(@body['parent']).to eq(parent.id)
      end

      context 'edge cases' do
        let!(:other_workspace) { FactoryBot.create(:workspace, users: [user]) }
        let!(:parent) { FactoryBot.create(:category, workspace: other_workspace) }
        let!(:params) { { name: 'Test', parent: parent.id } }

        it 'fails if we try to link it to a different workspace\'s category' do
          expect(response.status).to eq(422)
        end
      end
    end

    context 'authorization' do
      let!(:other_user) { FactoryBot.create(:user) }
      let!(:workspace_id) { other_user.workspaces.first.id }

      it 'returns error 403 for trying to access another users categories' do
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'update' do
    let!(:category) { user.workspaces.first.categories.first }
    let!(:url) { workspace_category_path(workspace_id, category.id) }
    let!(:params) { { name: 'Renamed category' } }

    before do
      put url, headers: headers, params: params
      begin
        @body = JSON.parse(response.body)
      rescue
        # ignored
      end
    end

    context 'happycase' do
      it 'successfully renames the category' do
        expect(response.status).to eq(200)
        expect(@body['name']).to eq(params[:name])
      end
    end

    context 'relink to a different parent' do
      let!(:other_category) { user.workspaces.first.categories.second }
      let!(:params) { { name: 'Renamed category', parent: other_category.id } }

      it 'successfully renames the category' do
        expect(response.status).to eq(200)
        expect(@body['name']).to eq(params[:name])
        expect(@body['parent']).to eq(other_category.id)
      end
    end
  end
end