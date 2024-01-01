class ApplicationController < ActionController::API
  include AuthenticationConcern
  include AuthorizationConcern
end
