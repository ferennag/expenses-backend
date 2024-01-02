class WorkspaceBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description

  view :full do
    association :accounts, blueprint: AccountBlueprint
  end
end