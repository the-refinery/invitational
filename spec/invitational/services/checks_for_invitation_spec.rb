require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::ChecksForInvitation do
  Given {no_invitations_exist}

  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:user3) { setup_user "test3@d-i.co" }

  Given(:entity) { setup_entity "Test entity"}

  Given {invite_user user1, entity, :user}
  Given {invite_uber_admin user3}

  context "checking for any role" do

    context "when invited" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity }

      Then {result.should be_true}
    end

    context "when not invited" do
      When(:result) { Invitational::ChecksForInvitation.for user2, entity }

      Then {result.should_not be_true}
    end

    context "when uber admin" do
      When(:result) { Invitational::ChecksForInvitation.for user3, entity }

      Then {result.should be_true}
    end

  end

  context "checking for specific role" do
    context "when invited in that role" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity, :user }

      Then {result.should be_true}
    end

    context "when invited in another role" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity, :admin }

      Then {result.should_not be_true}
    end

    context "when not invited" do
      When(:result) { Invitational::ChecksForInvitation.for user2, entity, :user }

      Then {result.should_not be_true}
    end

    context "when uber admin" do
      When(:result) { Invitational::ChecksForInvitation.for user3, entity, :user }

      Then {result.should be_true}
    end
  end

  context "checking for any of an array of roles" do
    context "when invited to one of the roles" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity, [:user, :admin] }

      Then {result.should be_true}
    end

    context "when invited in another role" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity, [:none, :admin] }

      Then {result.should_not be_true}
    end

    context "when not invited" do
      When(:result) { Invitational::ChecksForInvitation.for user2, entity, [:user, :admin] }

      Then {result.should_not be_true}
    end

    context "when uber admin" do
      When(:result) { Invitational::ChecksForInvitation.for user3, entity, [:user, :admin] }

      Then {result.should be_true}
    end

  end

end
