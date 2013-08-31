module Invitational
  module CanCan
    module Ability
      def can(action = nil, subject = nil, conditions = nil, &block)
        roles = conditions.delete(:roles) if conditions
        conditions = nil if conditions and conditions.empty?
        key = subject.name.underscore + action.to_s

        if roles.respond_to? :values
          role_type, roles  = [roles.keys.first, roles.values.first]
        else
          role_type = subject
        end

        role_mappings[key] = roles

        block ||= ->(model){
          roles = role_mappings[key]
          check_permission_for model, user, roles
        }

        rules << ::CanCan::Rule.new(true, action, subject, conditions, block)
      end

      def check_permission_for model, user, in_roles
        entity_roles  = in_roles.select {|role| role unless role.respond_to? :values}
        related_roles  = in_roles.select {|role| role if role.respond_to? :values}

        Invitational::ChecksForInvitation.for(user, model, entity_roles)
      end
    end
  end
end
