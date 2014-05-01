require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::Invitation do
  Given {no_invitations_exist}

  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:user3) { setup_user "test3@d-i.co" }
  Given(:user4) { setup_user "test4@d-i.co" }
  Given(:user5) { setup_user "test5@d-i.co" }

  Given(:entity1) { setup_entity "Test entity 1"}
  Given(:entity2) { setup_entity "Test entity 2"}
  Given(:entity3) { setup_entity "Test entity 3"}

  Given (:unclaimed) {invite_by_email user1.email, entity1, :user}
  Given (:claimed) {invite_user user2, entity2, :admin}
  Given (:uber_admin) {invite_uber_admin user3}

  context "Initialization" do
    context "Creates Claim hash and date sent on creation" do
      Given(:new_invite) {Invitation.new(email: "test999@d-i.co", invitable: entity1, role: :user)}

      When {new_invite.save}

      Then {new_invite.claim_hash.should_not be_nil}
      And  {new_invite.date_sent.should_not be_nil}
    end
  end

  context "Role Title" do
    context "Standard Role" do
      Then {unclaimed.role_title.should == "User"}
    end

    context "Uber Admin" do
      Then {uber_admin.role_title.should == "Uber Admin"}
    end
  end

  context "Type" do
    context "Standard Role" do
      Then {unclaimed.uberadmin?.should_not be_true}
      And  {claimed.uberadmin?.should_not be_true}
    end

    context "Uber Admin" do
      Then {uber_admin.uberadmin?.should be_true}
    end
  end

  context "Claim Status" do
    context "Unclaimed" do
      Then {unclaimed.claimed?.should_not be_true}
      And  {unclaimed.unclaimed?.should be_true}
    end

    context "Claimed" do
      Then {claimed.claimed?.should be_true}
      And  {claimed.unclaimed?.should_not be_true}
    end
  end

  context "Claiming" do
    context "By Hash" do
      When (:result) {Invitation.claim unclaimed.claim_hash, user1}

      Then  { result.id.should == unclaimed.id}
      And   { user1.invitations.should include(result) }
    end

    context "All for a given user" do
      Given {invite_by_email user4.email, entity3, :user}

      When (:result) {Invitation.claim_all_for user4}

      Then {user4.entities.should include(entity3)}
    end
  end

  context "Invites Uberadmin" do
    context "By email" do
      When (:result) {Invitation.invite_uberadmin user4.email}

      Then  {result.should_not be_nil}
      And   {result.invitable.should be_nil}
      And   {result.email.should == user4.email}
      And   {result.role.should == :uberadmin }
      And   {result.unclaimed?.should be_true}
    end

    context "Existing user" do
      When (:result) {Invitation.invite_uberadmin user4}

      Then  {result.should_not be_nil}
      And   {result.invitable.should be_nil}
      And   {result.email.should == user4.email}
      And   {result.role.should == :uberadmin}
      And   {result.claimed?.should be_true}
      And   {result.user.should == user4 }
    end

    context "When already invited" do
      Given {invite_uber_admin user4}

      When (:result) {Invitation.invite_uberadmin user4}

      Then  { expect(result).to have_failed(Invitational::AlreadyInvitedError) }
    end

    context "Invites to System Role" do
      context "By email" do
        When (:result) {Invitation.invite_system_user user4.email, :employer}

        Then  {result.should_not be_nil}
        And   {result.invitable.should be_nil}
        And   {result.email.should == user4.email}
        And   {result.role.should == :employer }
        And   {result.unclaimed?.should be_true}
      end

      context "Existing user" do
        When (:result) {Invitation.invite_system_user user4, :employer}

        Then  {result.should_not be_nil}
        And   {result.invitable.should be_nil}
        And   {result.email.should == user4.email}
        And   {result.role.should == :employer}
        And   {result.claimed?.should be_true}
        And   {result.user.should == user4 }
      end

      context "When already invited" do
        Given {invite_system_role user4, :employer}

        When (:result) {Invitation.invite_system_user user4, :employer}

        Then  { expect(result).to have_failed(Invitational::AlreadyInvitedError) }
      end
    end
  end


end
