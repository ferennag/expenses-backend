# This controller is used as a base for other controllers that are under the workspace namespace
class WorkspaceBaseController < ApplicationController

  protected

  def workspace_id_param
    :workspace_id
  end

  def load_workspace(authorization_query = nil)
    workspace_id = params.require(workspace_id_param)
    workspace = Workspace.find(workspace_id)
    if authorization_query
      @workspace = authorize workspace, authorization_query
    else
      @workspace = authorize workspace
    end
  end
end