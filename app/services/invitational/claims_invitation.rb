module Invitational
  class ClaimsInvitation

    attr_reader :success,
                :invitation

    def self.for claim_hash, user
      ClaimsInvitation.new claim_hash, user
    end

    def initialize claim_hash, user
      @invitation = Invitation.for_claim_hash(claim_hash).first

      if invitation && invitation.unclaimed?
        @invitation.user = user
        @success = @invitation.save
      else
        @invitation = nil
        @success = false
      end
    end

  end
end
