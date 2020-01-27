require 'spec_helper'
require 'cancan/matchers'
require 'invitational/services/service_helper'

describe Ability do

  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:user3) { setup_user "test3@d-i.co" }
  Given(:user4) { setup_user "test4@d-i.co" }
  Given(:user5) { setup_user "test5@d-i.co" }

  Given(:entity1) { setup_entity "Test entity 1"}
  Given(:entity2) { setup_entity "Test entity 2"}
  Given(:child1) {setup_child "Child 1", entity2}
  Given(:grandparent) {setup_grandparent "A Grandparent", entity2}

  Given(:other_entity) { setup_other_entity "Test other entity"}
  Given(:system_thing) { setup_system_thing "A System Object" }

  Given {invite_user user1, entity1, :user}
  Given {invite_user user2, entity2, :admin}
  Given {invite_user user5, grandparent, :admin}

  Given {invite_uber_admin user3}
  Given {invite_system_role user4, :employer}

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

  context "Any Role (wildcard)" do
    Given (:user) { Ability.new(user1) }
    Given (:admin) { Ability.new(user2) }
    When (:role) {:*}

    Then { user.should be_able_to(:validate, entity1) }
    And { user.should_not be_able_to(:validate, entity2) }
    And { admin.should be_able_to(:validate, entity2) }
    And { admin.should_not be_able_to(:validate, entity1) }
  end

  context "System - Employer" do
    Given (:i) { Ability.new(user4) }
    When (:role) {:employer}

    Then { i.should be_able_to(:manage, system_thing) }
  end

  context "Uber Admin" do
    Given (:i) { Ability.new(user3) }
    When (:role) {:uberadmin}

    Then { i.should be_able_to(:manage, entity1) }
    And { i.should be_able_to(:manage, entity2) }
    And {i.should be_able_to(:manage, child1)}
    And { i.should be_able_to(:manage, other_entity) }
    And { i.should be_able_to(:manage, system_thing) }
  end

  context "Uber Admin only permissions" do
    Given (:i) { Ability.new(user3) }
    When (:role) {:uberadmin}

    Then { i.should be_able_to(:manage, other_entity) }
  end

  context "Cascading Permissions" do
    context "One level" do
      Given (:i) { Ability.new(user2) }
      When (:role) {:admin}

      Then {i.should be_able_to(:manage, child1)}
    end

    context "Two levels" do
      Given (:i) { Ability.new(user5) }
      When (:role) {:admin}

      Then {i.should be_able_to(:manage, child1)}
    end
  end

  context "Access to everybody" do
    Given (:i) { Ability.new(user1) }
    When (:role) {:admin}

    Then {i.should be_able_to(:read, child1) }
  end

end
