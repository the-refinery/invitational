module Invitational
  class CreatesUberAdminInvitation
    attr_reader :success,
                :invitation

    def self.for target
      if target.is_a? String
        user = nil
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
      invitation.user = user
      invitation.save

      invitation
    end

  end
end
