class AccountBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description
end