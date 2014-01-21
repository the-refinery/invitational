module Invitational
  class CreatesInvitation

    attr_reader :success,
                :invitation

    def self.for invitable, email, role, user=nil
      CreatesInvitation.new invitable, email, role, user
    end

    def initialize invitable, email, role, user=nil

      unless invitable.invitations.for_email(email).count > 0
        @invitation = ::Invitation.new(invitable: invitable, role: role, email: email)
        @invitation.user = user
        @success = @invitation.save
      else
        @success = false
      end

    end

  end
end
