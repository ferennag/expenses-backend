class WorkspaceBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description

  view :full do
    association :users, blueprint: UserBlueprint
    association :accounts, blueprint: AccountBlueprint
    association :categories, blueprint: CategoryBlueprint
  end
end