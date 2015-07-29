module Invitational
  module InvitedTo
    extend ActiveSupport::Concern

    included do
      has_many :invitations, dependent: :destroy

      Invitation.system_roles.each do |role_name|
        scope role_name.to_s.pluralize, -> { joins(:invitations).merge Invitation.for_system_role(role_name) }
      end
    end

    module ClassMethods
      def invited_to *args
        args.each do |entity|
          relation = entity.to_s.pluralize.to_sym
          type = entity.to_s.camelize

          has_many relation, through: :invitations, source: :invitable, source_type: type
        end
      end
    end

    def uberadmin?
      invitations.uberadmin.count > 0
    end

    def invited_to? entity, role=nil
      Invitational::ChecksForInvitation.for self, entity,role
    end

    def invited_to_system? role
      invitations.for_system_role(role).count > 0
    end

  end
end
