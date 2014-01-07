require 'invitational/cancan'

class Ability
  include CanCan::Ability
  include Invitational::CanCan::Ability

  attr_reader :role_mappings, :<%= @identity_model %>

  def initialize(<%= @identity_model %>)

    @role_mappings = {}
    @<%= @identity_model %> = <%= @identity_model %>

    # Example:
    # can :manage, Entity, roles: [:admin]

  end

end
