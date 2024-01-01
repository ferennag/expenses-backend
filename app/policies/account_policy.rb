class AccountPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @record.workspace.users.include? @user
  end

  def show?
    @record.workspace.users.include? @user
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    @record.workspace.users.include? @user
  end

  def edit?
    update?
  end

  def destroy?
    @record.workspace.users.include? @user
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.joins(:workspace).joins(workspace: :users).where(workspace: { users: @user })
    end

    private

    attr_reader :user, :scope
  end
end