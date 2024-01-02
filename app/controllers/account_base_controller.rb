class AccountBaseController < WorkspaceBaseController
  protected

  def load_account(authorization_query = nil)
    account_id = params.require(:account_id)
    account = Account.find(account_id)

    if authorization_query
      @account = authorize account, authorization_query
    else
      @account = authorize account
    end
  end

  def account_id
    :account_id
  end
end