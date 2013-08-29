require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::ClaimsAllInvitations do
  Given(:user) { setup_user "test@d-i.co" }
  Given(:entity1) { setup_entity "Test entity 1"}
  Given(:entity2) { setup_entity "Test entity 2"}

  context "with pending invitation for email" do
    Given!(:invitation1) {invite_by_email user.email, entity1, :user}
    Given!(:invitation2) {invite_by_email user.email, entity2, :user}

    When { Invitational::ClaimsAllInvitations.for user }

    Then { user.invitations.should include(invitation1) }
    And  { user.invitations.should include(invitation2) }
  end

  context "with pending invitation for another email" do
    Given!(:invitation) {invite_by_email "foo@d-i.co", entity1, :user}

    When { Invitational::ClaimsAllInvitations.for user }

    Then { user.invitations.should_not include(invitation) }
  end

end
