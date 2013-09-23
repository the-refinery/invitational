require 'spec_helper'
require 'cancan/matchers'
require 'invitational/services/service_helper'

describe Ability do

  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:user3) { setup_user "test3@d-i.co" }

  Given(:entity) { setup_entity "Test entity"}

  Given {invite_user user1, entity, :user}
  Given {invite_user user2, entity, :admin}
  Given {invite_uber_admin user3}

  context "User" do
    Given (:i) { Ability.new(user1) }
    When (:role) {:user}

    Then { i.should be_able_to(:read, entity) }
    Then { i.should_not be_able_to(:manage, entity) }
  end

  context "Admin" do
    Given (:i) { Ability.new(user2) }
    When (:role) {:admin}

    Then { i.should be_able_to(:read, entity) }
    Then { i.should be_able_to(:manage, entity) }
  end

  context "Uber Admin" do
    Given (:i) { Ability.new(user3) }
    When (:role) {:uber_admin}

    Then { i.should be_able_to(:read, entity) }
    Then { i.should be_able_to(:manage, entity) }
  end


end
