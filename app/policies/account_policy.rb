class AccountPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    @user.workspaces.include? record.workspace
  end

  def show?
    @user.workspaces.include? record.workspace
  end

  def create?
    true
  end

  def update?
    @user.workspaces.include? record.workspace
  end

  def destroy?
    @user.workspaces.include? record.workspace
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.includes(workspace: :users).where(workspace: { users: @user })
    end

    private

    attr_reader :user, :scope
  end
end