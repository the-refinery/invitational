require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::ClaimsInvitation do
  Given(:user) { setup_user "test@d-i.co" }
  Given(:entity) { setup_entity "Test entity"}

  context "for unclaimed invitation" do
    context "invitation is to the user's email" do
      Given!(:invitation) {invite_by_email user.email, entity, :admin}

      When (:result) { Invitational::ClaimsInvitation.for invitation.claim_hash, user }

      Then  { result.success.should be_true }
      And   { result.invitation.should == invitation}
      And   { user.invitations.should include(invitation) }
    end

    context "invitation is to another email" do
      Given!(:invitation) {invite_by_email "foo@d-i.co", entity, :admin}

      When (:result) { Invitational::ClaimsInvitation.for invitation.claim_hash, user }

      Then  { result.success.should be_true }
      And   { result.invitation.should == invitation}
      And   { user.invitations.should include(invitation) }
    end
  end

  context "for claimed invitation" do
    Given(:user2) {setup_user "foo@bar.com"}
    Given(:invitation) {invite_user user2, entity, :admin}

    When (:result) { Invitational::ClaimsInvitation.for invitation.claim_hash, user }

    Then  { result.success.should be_false }
    And   { result.invitation.should be_nil }
    And   { invitation.user.should == user2 }
    And   { user.invitations.should_not include(invitation) }
  end

end
