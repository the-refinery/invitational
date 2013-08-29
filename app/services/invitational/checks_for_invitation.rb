module Invitational
  class ChecksForInvitation

    def self.for user, invitable, role=nil
      self.uber_admin?(user) || self.specific_invite?(user, invitable, role)
    end

private 

    def self.uber_admin? user
      user.invitations.uber_admin.count == 1
    end

    def self.specific_invite? user, invitable, role
      invites = user.invitations.for_invitable(invitable.class.name, invitable.id)

      if invites.count > 0
        unless role.nil?
          invites.first.role == Invitational::Role[role]
        else
          true
        end
      end
    end

  end
end
