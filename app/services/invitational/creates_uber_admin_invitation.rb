module Invitational
  class CreatesUberAdminInvitation
    attr_reader :success,
                :invitation

    def self.for target
      if target.is_a? String
        email = target

        if Invitation.uberadmin.for_email(email).count > 0
          raise Invitational::AlreadyInvitedError.new
        end
      else
        user = target
        email = user.email

        if user.uberadmin?
          raise Invitational::AlreadyInvitedError.new
        end
      end

      invitation = ::Invitation.new(role: :uberadmin, email: email)
      if user
        invitation.user = user
        invitation.date_accepted = DateTime.now
      end 
      invitation.save

      invitation
    end

  end
end
