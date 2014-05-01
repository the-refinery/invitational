module Invitational
  class CreatesSystemUserInvitation
    attr_reader :success,
                :invitation

    def self.for target, role
      if target.is_a? String
        email = target

        if Invitation.for_system_role(role).for_email(email).count > 0
          raise Invitational::AlreadyInvitedError.new
        end

      else
        user = target
        email = user.email

        if user.invited_to_system? role
          raise Invitational::AlreadyInvitedError.new
        end
      end

      invitation = ::Invitation.new(role: role, email: email)
      if user
        invitation.user = user
        invitation.date_accepted = DateTime.now
      end 
      invitation.save

      invitation
    end

  end
end
