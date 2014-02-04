require 'spec_helper'
require 'invitational/services/service_helper'

describe User do
  Given {no_invitations_exist}

  Given(:user1) { setup_user "test1@d-i.co" }
  Given(:user2) { setup_user "test2@d-i.co" }
  Given(:entity1) { setup_entity "Test entity 1"}

  context 'invited_to creates a has_many_through relationship' do
    When {invite_user user1, entity1, :admin}

    Then {user1.entities.should include(entity1)}
    And  {user1.children.count.should == 0}
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

  context 'checks to see if a user is invited to a given entity' do

    context 'for any role' do
      context 'when invited' do
        When {invite_user user1, entity1, :admin}

        Then {user1.invited_to?(entity1).should be_true}
      end

      context 'when not invited' do
        When {invite_user user2, entity1, :admin}

        Then {user1.invited_to?(entity1).should_not be_true}
      end
    end


    context 'for a specific role' do
      When {invite_user user1, entity1, :admin}

      context 'when invited' do
        Then {user1.invited_to?(entity1, :admin).should be_true}
      end

      context 'when not invited' do
        Then {user2.invited_to?(entity1, :admin).should_not be_true}
      end

      context 'when invited to a different role' do
        Then {user1.invited_to?(entity1, :user).should_not be_true}
      end
    end

  end

  context "cleans up invitations when a user is deleted" do
    Given! (:invite) {invite_user user1, entity1, :admin}
    Given {user1.destroy}

    When (:result) {Invitation.find(invite.id)}

    Then {expect(result).to have_failed(ActiveRecord::RecordNotFound)}
  end

end

