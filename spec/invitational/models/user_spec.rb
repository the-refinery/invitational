require 'spec_helper'
require 'invitational/services/service_helper'

describe User do
  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:entity1) { setup_entity "Test entity 1"}

  context 'invited_to should create a has_many_through relationship' do
    When {invite_user user1, entity1, :admin}

    Then {user1.entities.should include(entity1)}
    And  {user1.children.count.should == 0}
  end

end

