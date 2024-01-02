class WorkspacePolicy < ApplicationPolicy
  attr_reader :user, :workspace

  def initialize(user, workspace)
    @user = user
    @workspace = workspace
  end

  def index?
    @user.workspaces.include? @workspace
  end

  def show?
    @user.workspaces.include? @workspace
  end

  def create?
    true
  end

  def update?
    @user.workspaces.include? @workspace
  end

  def destroy?
    @user.workspaces.include? @workspace
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