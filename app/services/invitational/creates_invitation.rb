module Invitational
  class CreatesInvitation

    attr_reader :success,
                :invitation

    def self.for invitable, target, role
      CreatesInvitation.new invitable, target, role
    end

    def initialize invitable, target, role

      if target.is_a? String
        user = nil
        email = target
      else
        user = target
        email = user.email
      end

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
