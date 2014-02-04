require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::ClaimsInvitation do
  Given {no_invitations_exist}

  Given(:user) { setup_user "test@d-i.co" }
  Given(:entity) { setup_entity "Test entity"}

  context "for unclaimed invitation" do
    context "invitation is to the user's email" do
      Given!(:invitation) {invite_by_email user.email, entity, :admin}

      When (:result) { Invitational::ClaimsInvitation.for invitation.claim_hash, user }

      Then  { result.should == invitation}
      And   { user.invitations.should include(invitation) }
    end

    context "invitation is to another email" do
      Given!(:invitation) {invite_by_email "foo@d-i.co", entity, :admin}

      When (:result) { Invitational::ClaimsInvitation.for invitation.claim_hash, user }

      Then  { result.should == invitation}
      And   { user.invitations.should include(invitation) }
    end
  end

  context "for claimed invitation" do
    Given(:user2) {setup_user "foo@bar.com"}
    Given(:invitation) {invite_user user2, entity, :admin}

    When (:result) { Invitational::ClaimsInvitation.for invitation.claim_hash, user }

    Then  { expect(result).to have_failed(Invitational::AlreadyClaimedError) }
    And   { user.invitations.should_not include(invitation) }
  end

  context "If the invitation hash is bad" do
    Given!(:invitation) {invite_by_email user.email, entity, :admin}

    When (:result) { Invitational::ClaimsInvitation.for "THIS_IS_A_BAD_HASH", user }

    Then  { expect(result).to have_failed(Invitational::InvitationNotFoundError) }
    And   { user.invitations.should_not include(invitation) }
  end

end
