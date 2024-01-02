class AccountsController < WorkspaceBaseController
  before_action :load_workspace

  def show
    account = Account.find(params.require(:id))
    authorize account

    render json: AccountBlueprint.render(account)
  end

  def index
    accounts = policy_scope(Account)
    accounts = accounts.where(workspace_id: @workspace.id)

    render json: AccountBlueprint.render(accounts)
  end

  def create
    authorize Account, :create?

    name, description = params.require([:name, :description])

    account = Account.create!(name: name, description: description, workspace: @workspace)
    render json: AccountBlueprint.render(account)
  end

  def update
    account = Account.eager.find(params.require(:id))
    authorize account
    account.update(params.permit([:name, :description]))

    render json: AccountBlueprint.render(account)
  end

  # TODO
  # Add ability to delete accounts. Deletion should only be an archiving, and users should be able to restore it later
end
