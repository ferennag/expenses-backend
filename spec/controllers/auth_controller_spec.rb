require 'rails_helper'

RSpec.describe AuthController, type: :request do
  include ControllerSpecHelpers

  let!(:admin) { FactoryBot.create(:user) }

  describe '/login' do
    context 'happycase' do
      it 'successfully authenticates an existing user' do
        post login_path, params: { email: admin.email, password: admin.password }
        expect(response.status).to eq(200)

        body = response.body
        expect(body['token']).to be_truthy
      end

      it 'returns a valid JWT token' do
        post login_path, params: { email: admin.email, password: admin.password }
        token = JSON.parse(response.body)['token']
        expect(token).to be_truthy
        decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, false)
        expect(decoded).to be_truthy
        expect(decoded[0]['email']).to eq(admin.email)
      end
    end

    context 'invalid password' do
      it 'returns a 401 error' do
        post login_path, params: { email: admin.email, password: 'invalid' }
        expect(response.status).to eq(401)
      end
    end

    context 'invalid user' do
      it 'returns a 401 error' do
        post login_path, params: { email: 'invalid_email@example.com', password: admin.password }
        expect(response.status).to eq(401)
      end
    end
  end

  describe '/logout' do
    let!(:headers) { stub_auth_headers(admin.email) }

    context 'happycase' do
      it 'returns a 200 response' do
        post logout_path, headers: headers
        expect(response.status).to eq(200)
      end
    end

    context 'without credentials' do
      it 'returns a 401 response' do
        post logout_path, headers: {}
        expect(response.status).to eq(401)
      end
    end

    context 'incorrect credentials' do
      it 'returns a 401 response' do
        post logout_path, headers: stub_auth_headers('invalid@example.com')
        expect(response.status).to eq(401)
      end
    end
  end
end