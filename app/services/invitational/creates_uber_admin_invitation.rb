module Invitational
  class CreatesUberAdminInvitation
    attr_reader :success,
                :invitation

    def self.for email, user=nil
      CreatesUberAdminInvitation.new email, user
    end

    def initialize email, user=nil

      unless Invitation.uber_admin.for_email(email).count > 0
        @invitation = Invitation.new(role: -1, email: email)
        @invitation.user = user
        @success = @invitation.save
      else
        @success = false
      end

    end

  end
end
