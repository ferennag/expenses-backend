class WorkspacesController < WorkspaceBaseController
  before_action :load_workspace, except: [:index, :create]

  def index
    workspaces = policy_scope(Workspace)
    render json: WorkspaceBlueprint.render(workspaces.all)
  end

  def create
    authorize Workspace, :create?
    workspace = Workspace.create!(params.permit([:name, :description]))
    workspace.users << current_user
    render json: WorkspaceBlueprint.render(workspace)
  end

  def show
    render json: WorkspaceBlueprint.render(@workspace)
  end

  def update
    @workspace.update!(params.permit([:name, :description]))
    render json: WorkspaceBlueprint.render(@workspace)
  end

  # TODO add ability to delete a workspace

  protected

  def workspace_id_param
    :id
  end
end
