require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::ChecksForInvitation do
  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }

  Given(:entity) { setup_entity "Test entity"}

  Given {invite_user user1, entity, 1}

  context "checking for any role" do

    context "when invited" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity }

      Then {result.should be_true}
    end

    context "when not invited" do
      When(:result) { Invitational::ChecksForInvitation.for user2, entity }

      Then {result.should_not be_true}
    end

  end

  context "checking for specific role" do
    context "when invited in that role" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity, 1 }

      Then {result.should be_true}
    end

    context "when invited in another role" do
      When(:result) { Invitational::ChecksForInvitation.for user1, entity, 2 }

      Then {result.should_not be_true}
    end

    context "when not invited" do
      When(:result) { Invitational::ChecksForInvitation.for user2, entity, 1 }

      Then {result.should_not be_true}
    end

  end

end
