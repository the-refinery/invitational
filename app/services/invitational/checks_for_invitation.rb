module Invitational
  class ChecksForInvitation

    def self.for user, invitable, role=nil
      invites = user.invitations.for_invitable(invitable.class.name, invitable.id)

      if invites.count > 0
        unless role.nil?
          invites.first.role == role
        else
          true
        end
      end
    end
  end
end
