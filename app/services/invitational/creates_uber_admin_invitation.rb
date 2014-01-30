module Invitational
  class CreatesUberAdminInvitation
    attr_reader :success,
                :invitation

    def self.for target
      if target.is_a? String
        user = nil
        email = target

        if Invitation.uber_admin.for_email(email).count > 0
          raise Invitational::AlreadyInvitedError.new
        end
      else
        user = target
        email = user.email

        if user.uber_admin?
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
