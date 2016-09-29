require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::CreatesInvitation do
  Given {no_invitations_exist}

  Given(:entity) { setup_entity "Test Entity"}

  context "by email" do

    context "when not already invited" do
      When (:result) {Invitational::CreatesInvitation.for entity, "test@d-i.co", :admin}

      Then  {result.should_not be_nil}
      And   {result.invitable.should == entity}
      And   {result.email.should == "test@d-i.co"}
      And   {result.role.should == :admin}
      And   {result.unclaimed?.should be_truthy}
    end

    context "when already invited" do
      Given {::Invitation.new(invitable: entity, role: :admin, email: 'test@d-i.co').save}

      When (:result) {Invitational::CreatesInvitation.for entity, "test@d-i.co", :admin}

      Then  { expect(result).to have_failed(Invitational::AlreadyInvitedError) }
    end

  end

  context "to be immediately claimed" do
    Given(:user) { setup_user "test@d-i.co" }

    context "when not already invited" do
      When (:result) {Invitational::CreatesInvitation.for entity, user, :admin}

      Then  {result.should_not be_nil}
      And   {result.invitable.should == entity}
      And   {result.email.should == "test@d-i.co"}
      And   {result.role.should == :admin}
      And   {result.claimed?.should be_truthy}
      And   {result.user.should == user }
    end

    context "when already invited" do
      Given {::Invitation.new(invitable: entity, role: :admin, email: 'test@d-i.co', user: user).save}

      When (:result) {Invitational::CreatesInvitation.for entity, user, :admin}

      Then  { expect(result).to have_failed(Invitational::AlreadyInvitedError) }
    end

  end

end
