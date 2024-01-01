class AccountsController < ApplicationController
  def index
    workspace_id = params.require(:workspace_id)
    workspace = Workspace.find(workspace_id)
    authorize workspace

    accounts = policy_scope(Account)
    accounts = accounts.where(workspace_id: workspace_id)

    render json: accounts
  end
end
