require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::ClaimsAllInvitations do
  def create_invitation email, council
    invitation = Invitational::Invitation.new(email: email, role: 2)
    invitation.invitable = council
    invitation.save

    invitation
  end

  Given(:user) { setup_user "test@d-i.co" }
  Given(:entity) { setup_entity "Test entity"}

  context "with pending invitation for email" do
    Given!(:invitation) {create_invitation user.email, entity}

    When { Invitational::ClaimsAllInvitations.for user }

    Then { user.invitations.should include(invitation) }
  end

  context "with pending invitation for another email" do
    Given!(:invitation) {create_invitation "foo@bar.com", entity}

    When { Invitational::ClaimsAllInvitations.for user }

    Then { user.invitations.should_not include(invitation) }
  end

end
