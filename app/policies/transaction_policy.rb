# frozen_string_literal: true

class TransactionPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    false
  end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    true
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.joins(account: { workspace: :users }).where(account: { workspace: { users: @user } })
    end

    private

    attr_reader :user, :scope
  end
end
