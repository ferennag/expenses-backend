class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email

  view :full do
    association :workspaces, blueprint: WorkspaceBlueprint, view: :full
  end
end