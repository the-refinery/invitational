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

    can :read, Child

    can :manage, Child, roles: [:admin, attribute_roles(:entity, [:admin, :user]) ]

    can :manage, OtherEntity, roles: [:uberadmin]

  end

end

