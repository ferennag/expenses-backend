# This controller is used as a base for other controllers that are under the workspace namespace
class WorkspaceBaseController < ApplicationController

  protected

  def workspace_id_param
    :workspace_id
  end

  def load_workspace
    workspace_id = params.require(workspace_id_param)
    workspace = Workspace.find(workspace_id)
    @workspace = authorize workspace
  end
end