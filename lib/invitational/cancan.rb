module Invitational
  module CanCan
    module Ability
      include ::CanCan::Ability

      def can(action = nil, subject = nil, conditions = nil, &block)
        if conditions && conditions.has_key?(:roles)
          roles = conditions.delete(:roles) if conditions
          conditions = nil if conditions and conditions.empty?

          block ||= setup_role_based_block_for roles, subject, action, false
        end

        add_rule ::CanCan::Rule.new(true, action, subject, conditions, &block)
      end

      def cannot(action = nil, subject = nil, conditions = nil, &block)
        if conditions && conditions.has_key?(:roles)
          roles = conditions.delete(:roles) if conditions
          conditions = nil if conditions and conditions.empty?

          block ||= setup_role_based_block_for roles, subject, action, true
        end

        add_rule ::CanCan::Rule.new(false, action, subject, conditions, &block)
      end

      def setup_role_based_block_for roles, subject, action, role_specific
        key = subject.name.underscore + action.to_s

        if roles.respond_to? :values
          role_type, roles  = [roles.keys.first, roles.values.first]
        else
          role_type = subject
        end

        unless role_mappings.has_key?(key)
          role_mappings[key] = []
        end

        role_mappings[key] += roles

        block = ->(model){
          roles = role_mappings[key]
          check_permission_for model, user, roles, role_specific
        }

        block
      end

      def check_permission_for model, user, in_roles, role_specific

        in_roles.inject(false) do |result,role|
          result || if role.respond_to? :values
            check_permission_for_keyed_roles model, user, role, role_specific
          elsif role == :*
            Invitational::ChecksForInvitation.for(user, model)
          else
            Invitational::ChecksForInvitation.for(user, model, role, role_specific)
          end
        end

      end

      def check_permission_for_keyed_roles model, user, role, role_specific
        key = role.keys.first

        if key == :system_roles
          check_permission_for_system_role user, role, role_specific
        else
          check_permission_for_attribute model, user, role, role_specific
        end
      end

      def check_permission_for_system_role user, role, role_specific
        roles = role.values.flatten

        user.uberadmin? || roles.any? do |system_role|
          user.invited_to_system? system_role
        end
      end

      def check_permission_for_attribute model, user, role, role_specific
        method = role.keys.first
        related = model.send(method)

        if related.respond_to? :any?
          related.any? do |model|
            check_permission_for model, user, role.values.flatten, role_specific
          end
        else
          check_permission_for related, user, role.values.flatten, role_specific
        end
      end

      def attribute_roles attribute, roles
        hash = nil
        if attribute.respond_to? :each
          attribute.reverse.each do |attr|
            if hash.nil?
              hash = {attr => roles}
            else
              hash = {attr => hash}
            end
          end
        else
          hash = {attribute => roles}
        end

        hash
      end

      def system_roles roles
        {system_roles: roles}
      end

    end
  end
end
