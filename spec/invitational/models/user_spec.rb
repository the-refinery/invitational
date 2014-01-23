require 'spec_helper'
require 'invitational/services/service_helper'

describe User do
  Given {no_invitations_exist}

  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:entity1) { setup_entity "Test entity 1"}

  context 'invited_to creates a has_many_through relationship' do
    When {invite_user user1, entity1, :admin}

    Then {user.entities.should include(entity)}
    And  {user.children.count.should == 0}
  end

  context 'indicates if a user is an uberadmin' do

    context 'when an uberadmin' do
      When {invite_uber_admin user2}

      Then {user2.uber_admin?.should be_true}
    end

    context 'when not an uberadmin' do
      When {invite_user user1, entity1, :admin}

      Then {user1.uber_admin?.should_not be_true}
    end

  end

end

