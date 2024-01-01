module ControllerSpecHelpers
  def stub_auth_headers(email)
    token = JWT.encode({ email: email }, Rails.application.credentials.secret_key_base)
    { 'Authorization': "Bearer #{token}" }
  end
end