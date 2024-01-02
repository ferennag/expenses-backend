class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :email

  association :workspaces, blueprint: WorkspaceBlueprint, view: :full
end