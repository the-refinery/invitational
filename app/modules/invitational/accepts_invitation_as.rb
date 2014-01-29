module Invitational
  module AcceptsInvitationAs
    extend ActiveSupport::Concern

    included do
      has_many :invitations, :as => :invitable, dependent: :destroy

      @@roles = Array.new

      def self.roles
        @@roles
      end
    end

    module ClassMethods

      def accepts_invitation_as *args
        args.each do |role|
          relation = role.to_s.pluralize.to_sym

          has_many relation, -> {where "invitations.role = '#{role.to_s}'"}, through: :invitations, source: :user

          self.roles << role
        end
      end
    end

    def invite target, role
      if @@roles.include? role
        Invitational::CreatesInvitation.for self, target, role
      end
    end

  end
end
