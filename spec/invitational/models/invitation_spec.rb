require 'spec_helper'
require 'invitational/services/service_helper'

describe Invitational::Invitation do
  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:user3) { setup_user "test3@d-i.co" }

  Given(:entity1) { setup_entity "Test entity 1"}
  Given(:entity2) { setup_entity "Test entity 1"}

  Given (:unclaimed) {invite_by_email user1.email, entity1, :user}
  Given (:claimed) {invite_user user2, entity2, :admin}
  Given (:uber_admin) {invite_uber_admin user3}

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
      Then {unclaimed.uber_admin?.should_not be_true}
      And  {claimed.uber_admin?.should_not be_true}
    end

    context "Uber Admin" do
      Then {uber_admin.uber_admin?.should be_true}
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

end
