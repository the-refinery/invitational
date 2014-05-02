module Invitational
  module CanCan
    module Ability

      def can(action = nil, subject = nil, conditions = nil, &block)
        if conditions && conditions.has_key?(:roles)
          roles = conditions.delete(:roles) if conditions
          conditions = nil if conditions and conditions.empty?

          block ||= setup_role_based_block_for roles, subject, action
        end

        rules << ::CanCan::Rule.new(true, action, subject, conditions, block)
      end

      def setup_role_based_block_for roles, subject, action
        key = subject.name.underscore + action.to_s

        if roles.respond_to? :values
          role_type, roles  = [roles.keys.first, roles.values.first]
        else
          role_type = subject
        end

        role_mappings[key] = roles

        block = ->(model){
          roles = role_mappings[key]
          check_permission_for model, user, roles
        }

        block
      end

      def check_permission_for model, user, in_roles

        in_roles.inject(false) do |result,role|
          result || if role.respond_to? :values
            check_permission_for_keyed_roles model, user, role
          else
            Invitational::ChecksForInvitation.for(user, model, role)
          end
        end

      end

      def check_permission_for_keyed_roles model, user, role
        key = role.keys.first

        if key == :system_roles
          check_permission_for_system_role user, role
        else
          check_permission_for_attribute model, user, role
        end
      end

      def check_permission_for_system_role user, role
        roles = role.values.flatten

        user.uberadmin? || roles.any? do |system_role|
          user.invited_to_system? system_role
        end
      end

      def check_permission_for_attribute model, user, role
        method = role.keys.first
        related = model.send(method)

        if related.respond_to? :any?
          related.any? do |model|
            check_permission_for model, user, role.values.flatten
          end
        else
          check_permission_for related, user, role.values.flatten
        end
      end

      def attribute_roles attribute, roles
        {attribute => roles}
      end

      def system_roles roles
        {system_roles: roles}
      end

    end
  end
end
