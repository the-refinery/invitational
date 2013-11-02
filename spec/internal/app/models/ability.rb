require 'invitational/cancan'

class Ability
  include CanCan::Ability
  include Invitational::CanCan::Ability

  attr_reader :role_mappings, :user

  def initialize(user)

    @role_mappings = {}
    @user = user

    can :manage, Entity, roles: [:admin]
    can :read, Entity, roles: [:user]

    can :manage, Child, roles: [:admin, {entity: [:admin, :user]}]

  end

end

