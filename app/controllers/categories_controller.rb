class CategoriesController < WorkspaceBaseController
  before_action :load_workspace, except: [:create]

  def index
    categories = policy_scope(Category)
    categories = categories.where(workspace_id: @workspace.id).order(name: :asc)
    render json: CategoryBlueprint.render(categories)
  end

  def create
    load_workspace :update?
    authorize Category, :create?

    category = Category.create!(params.permit([:name, :parent]).merge({ workspace: @workspace }))
    render json: CategoryBlueprint.render(category)
  end

  def show
    category = authorize Category.find(params.require(:id))
    render json: CategoryBlueprint.render(category)
  end

  def update
    category = authorize Category.find(params.require(:id))
    category.update!(params.permit([:name, :parent]))
    render json: CategoryBlueprint.render(category)
  end

  # TODO add deletion, here we will need to take care of the transaction associations first before deletion
end
