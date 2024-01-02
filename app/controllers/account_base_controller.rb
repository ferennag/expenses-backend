class AccountBaseController < WorkspaceBaseController
  protected

  def load_account(authorization_query = nil)
    account_id = params.require(account_id_param)
    account = Account.eager.find(account_id)

    if authorization_query
      @account = authorize account, authorization_query
    else
      @account = authorize account
    end
  end

  def account_id_param
    :account_id
  end
end