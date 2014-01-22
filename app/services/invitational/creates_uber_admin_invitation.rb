module Invitational
  class CreatesUberAdminInvitation
    attr_reader :success,
                :invitation

    def self.for target
      CreatesUberAdminInvitation.new target
    end

    def initialize target

      if target.is_a? String
        user = nil
        email = target
      else
        user = target
        email = user.email
      end

      unless Invitation.uber_admin.for_email(email).count > 0
        @invitation = ::Invitation.new(role: :uberadmin, email: email)
        @invitation.user = user
        @success = @invitation.save
      else
        @success = false
      end

    end

  end
end
