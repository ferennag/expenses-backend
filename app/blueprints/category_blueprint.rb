class CategoryBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :parent
end