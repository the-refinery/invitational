require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::CreatesSystemUserInvitation do
  Given {no_invitations_exist}

  context "by email" do
    context "when not already invited" do
      When (:result) {Invitational::CreatesSystemUserInvitation.for "test@d-i.co", :employer}

      Then  {result.should_not be_nil}
      And   {result.invitable.should be_nil}
      And   {result.email.should == "test@d-i.co"}
      And   {result.role.should == :employer }
      And   {result.unclaimed?.should be_true}
    end

    context "when already invited" do
      Given {::Invitation.new(role: :employer, email: 'test@d-i.co').save}

      When (:result) {Invitational::CreatesSystemUserInvitation.for "test@d-i.co", :employer}

      Then  { expect(result).to have_failed(Invitational::AlreadyInvitedError) }
    end

  end

  context "to be immediately claimed" do
    Given(:user) { setup_user "test2@d-i.co" }

    context "when not already invited" do
      When (:result) {Invitational::CreatesSystemUserInvitation.for user, :employer}

      Then  {result.should_not be_nil}
      And   {result.invitable.should be_nil}
      And   {result.email.should == "test2@d-i.co"}
      And   {result.role.should == :employer}
      And   {result.claimed?.should be_true}
      And   {result.user.should == user }
    end

    context "when already invited" do
      Given {::Invitation.new(role: :employer, email: 'test2@d-i.co', user: user).save}

      When (:result) {Invitational::CreatesSystemUserInvitation.for user, :employer}

      Then  { expect(result).to have_failed(Invitational::AlreadyInvitedError) }
    end

  end

end
