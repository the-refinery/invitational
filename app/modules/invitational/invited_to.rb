module Invitational
  module InvitedTo
    extend ActiveSupport::Concern

    included do
      has_many :invitations, dependent: :destroy
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

  end
end
