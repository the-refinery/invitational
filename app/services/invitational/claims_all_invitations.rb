module Invitational
  class ClaimsAllInvitations

    def self.for user
      pending_invitations = ::Invitation.pending_for(user.email)

      pending_invitations.each do |invite|
        invite.user = user
        invite.save
      end
    end
  end
end
