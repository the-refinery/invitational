module Invitational
  class ClaimsInvitation

    def self.for claim_hash, user
      invitation = Invitation.for_claim_hash(claim_hash).first

      if invitation.nil?
        raise Invitational::InvitationNotFoundError.new
      end

      if invitation.claimed?
        raise Invitational::AlreadyClaimedError.new
      end

      invitation.user = user
      invitation.save

      invitation
    end
  end
end
