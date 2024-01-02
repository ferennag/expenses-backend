class AccountsController < AccountBaseController
  before_action :load_workspace, except: [:create]
  before_action :load_account, except: [:index, :create]

  def index
    accounts = policy_scope(Account)
    accounts = accounts.where(workspace_id: @workspace.id)

    render json: AccountBlueprint.render(accounts)
  end

  def create
    load_workspace :update?
    authorize Account, :create?

    name, description = params.require([:name, :description])

    account = Account.create!(name: name, description: description, workspace: @workspace)
    render json: AccountBlueprint.render(account)
  end

  def show
    render json: AccountBlueprint.render(@account)
  end

  def update
    @account.update(params.permit([:name, :description]))

    render json: AccountBlueprint.render(@account)
  end

  # TODO
  # Add ability to delete accounts. Deletion should only be an archiving, and users should be able to restore it later

  protected

  def account_id_param
    :id
  end
end
