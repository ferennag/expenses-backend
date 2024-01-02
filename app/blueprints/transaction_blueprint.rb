class TransactionBlueprint < Blueprinter::Base
  identifier :id

  fields :amount, :date, :memo, :reference
end