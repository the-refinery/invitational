require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::CreatesInvitation do
  Given {no_invitations_exist}

  Given(:entity) { setup_entity "Test Entity"}

  context "by email" do

    context "when not already invited" do
      When (:result) {Invitational::CreatesInvitation.for entity, "test@d-i.co", :admin}

      Then  {result.success.should be_true }
      And   {result.invitation.should_not be_nil}
      And   {result.invitation.invitable.should == entity}
      And   {result.invitation.email.should == "test@d-i.co"}
      And   {result.invitation.role.should == :admin}
      And   {result.invitation.unclaimed?.should be_true}
    end

    context "when already invited" do
      Given {::Invitation.new(invitable: entity, role: :admin, email: 'test@d-i.co').save}

      When (:result) {Invitational::CreatesInvitation.for entity, "test@d-i.co", :admin}

      Then  {result.success.should be_false }
      And   {result.invitation.should be_nil}
    end

  end

  context "to be immediately claimed" do
    Given(:user) { setup_user "test@d-i.co" }

    context "when not already invited" do
      When (:result) {Invitational::CreatesInvitation.for entity, "test@d-i.co", :admin, user}

      Then  {result.success.should be_true }
      And   {result.invitation.should_not be_nil}
      And   {result.invitation.invitable.should == entity}
      And   {result.invitation.email.should == "test@d-i.co"}
      And   {result.invitation.role.should == :admin}
      And   {result.invitation.claimed?.should be_true}
      And   {result.invitation.user.should == user }
    end

    context "when already invited" do
      Given {::Invitation.new(invitable: entity, role: :admin, email: 'test@d-i.co', user: user).save}

      When (:result) {Invitational::CreatesInvitation.for entity, "test@d-i.co", :admin, user}

      Then  {result.success.should be_false }
      And   {result.invitation.should be_nil}
    end

  end

end
