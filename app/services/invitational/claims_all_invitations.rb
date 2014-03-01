module Invitational
  class ClaimsAllInvitations

    def self.for user
      pending_invitations = ::Invitation.pending_for(user.email)

      pending_invitations.each do |invitation|
        invitation.user = user
        invitation.date_accepted = DateTime.now
        invitation.save
      end
    end
  end
end
