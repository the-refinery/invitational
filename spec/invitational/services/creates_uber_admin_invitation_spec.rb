require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::CreatesUberAdminInvitation do
  Given {no_invitations_exist}

  context "by email" do
    context "when not already invited" do
      When (:result) {Invitational::CreatesUberAdminInvitation.for "test@d-i.co"}

      Then  {result.success.should be_true }
      And   {result.invitation.should_not be_nil}
      And   {result.invitation.invitable.should be_nil}
      And   {result.invitation.email.should == "test@d-i.co"}
      And   {result.invitation.role.should == :uberadmin }
      And   {result.invitation.unclaimed?.should be_true}
    end

    context "when already invited" do
      Given {::Invitation.new(role: :uberadmin, email: 'test@d-i.co').save}

      When (:result) {Invitational::CreatesUberAdminInvitation.for "test@d-i.co"}

      Then  {result.success.should be_false }
      And   {result.invitation.should be_nil}
    end

  end

  context "to be immediately claimed" do
    Given(:user) { setup_user "test2@d-i.co" }

    context "when not already invited" do
      When (:result) {Invitational::CreatesUberAdminInvitation.for "test2@d-i.co", user}

      Then  {result.success.should be_true }
      And   {result.invitation.should_not be_nil}
      And   {result.invitation.invitable.should be_nil}
      And   {result.invitation.email.should == "test2@d-i.co"}
      And   {result.invitation.role.should == :uberadmin}
      And   {result.invitation.claimed?.should be_true}
      And   {result.invitation.user.should == user }
    end

    context "when already invited" do
      Given {::Invitation.new(role: :uberadmin, email: 'test@d-i.co', user: user).save}

      When (:result) {Invitational::CreatesUberAdminInvitation.for "test@d-i.co", user}

      Then  {result.success.should be_false }
      And   {result.invitation.should be_nil}
    end

  end

end
