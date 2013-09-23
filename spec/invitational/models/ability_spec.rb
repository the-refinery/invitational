require 'spec_helper'
require 'cancan/matchers'
require 'invitational/services/service_helper'

describe Ability do

  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:user3) { setup_user "test3@d-i.co" }

  Given(:entity1) { setup_entity "Test entity 1"}
  Given(:entity2) { setup_entity "Test entity 1"}

  Given {invite_user user1, entity1, :user}
  Given {invite_user user2, entity2, :admin}
  Given {invite_uber_admin user3}

  context "User" do
    Given (:i) { Ability.new(user1) }
    When (:role) {:user}

    Then { i.should be_able_to(:read, entity1) }
    And { i.should_not be_able_to(:manage, entity1) }
    And { i.should_not be_able_to(:read, entity2) }
  end

  context "Admin" do
    Given (:i) { Ability.new(user2) }
    When (:role) {:admin}

    Then { i.should be_able_to(:read, entity2) }
    And { i.should be_able_to(:manage, entity2) }
    And { i.should_not be_able_to(:read, entity1) }
  end

  context "Uber Admin" do
    Given (:i) { Ability.new(user3) }
    When (:role) {:uber_admin}

    Then { i.should be_able_to(:manage, entity1) }
    And { i.should be_able_to(:manage, entity2) }
  end


end
