module Invitational
  class ClaimsInvitation

    def self.for claim_hash, user

      invitation = Invitational::Invitation.for_claim_hash(claim_hash).first

      if invitation && invitation.unclaimed?
        invitation.user = user
        invitation.save
      else
        false
      end

    end
  end
end
