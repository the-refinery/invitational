module Invitational
  module AcceptsInvitationAs
    extend ActiveSupport::Concern

    included do
      has_many :invitations, :as => :invitable

      @@roles = Array.new

      def self.roles
        @@roles
      end
    end

    module ClassMethods

      def accepts_invitation_as *args
        args.each do |role|
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
