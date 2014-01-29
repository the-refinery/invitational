module Invitational
  class ClaimsInvitation

    def self.for claim_hash, user
      invitation = Invitation.for_claim_hash(claim_hash).first

      if invitation && invitation.unclaimed?
        invitation.user = user
        invitation.save
        invitation
      else
        raise Invitational::AlreadyClaimedError.new
      end

    end
  end
end
