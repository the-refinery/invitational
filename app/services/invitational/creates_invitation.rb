module Invitational
  class CreatesInvitation

    def self.for invitable, target, role
      if target.is_a? String
        email = target

        if invitable.invitations.for_email(email).count > 0
          raise Invitational::AlreadyInvitedError
        end

      else
        user = target
        email = user.email

        if user.invitations.for_invitable(invitable.class, invitable.id).count > 0
          raise Invitational::AlreadyInvitedError
        end
      end

      invitation = ::Invitation.new(invitable: invitable, role: role, email: email)
      if user
        invitation.user = user
        invitation.date_accepted = DateTime.now
      end
      invitation.save

      invitation
    end

  end
end
