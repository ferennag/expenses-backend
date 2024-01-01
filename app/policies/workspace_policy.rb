class WorkspacePolicy < ApplicationPolicy
  attr_reader :user, :workspace

  def initialize(user, workspace)
    @user = user
    @workspace = workspace
  end

  def index?
    workspace.users.include? @user
  end

  def show?
    workspace.users.include? @user
  end

  def create?
    true
  end

  def update?
    workspace.users.include? @user
  end

  def destroy?
    workspace.users.include? @user
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.joins(:users).where(users: @user.id)
    end

    private

    attr_reader :user, :scope
  end
end