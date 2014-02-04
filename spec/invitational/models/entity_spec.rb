require 'spec_helper'
require 'invitational/services/service_helper'

describe Entity do
  Given {no_invitations_exist}

  Given(:user) { setup_user "test1@d-i.co" }
  Given(:entity) { setup_entity "Test entity 1"}

  context "relationships" do
    When {invite_user user, entity, :admin}

    Then {entity.admins.should include(user)}
  end

  context "inviting" do
    context "Users can be invited with a defined role" do
      When(:result) {entity.invite user, :admin}

      Then  {result.should_not be_nil}
      And   {result.invitable.should == entity}
      And   {result.user.should == user }
      And   {result.role.should == :admin}
      And   {result.claimed?.should be_true}
    end

    context "Users cannot be invited again if they are already invited" do
      Given {invite_user user, entity, :admin}

      When(:result) {entity.invite user, :user}

      Then  { expect(result).to have_failed(Invitational::AlreadyInvitedError) }
    end

    context "Users cannot be invited with a role that isn't defined on the entity" do
      When(:result) {entity.invite user, :client}

      Then  { expect(result).to have_failed(Invitational::InvalidRoleError) }
    end
  end

  context "cleans up invitations when an entity is deleted" do
    Given! (:invite) {invite_user user, entity, :admin}
    Given {entity.destroy}

    When (:result) {Invitation.find(invite.id)}

    Then {expect(result).to have_failed(ActiveRecord::RecordNotFound)}
  end

end
