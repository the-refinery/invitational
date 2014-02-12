module Invitational
  class ChecksForInvitation

    def self.for user, invitable, roles=nil
      self.uberadmin?(user) || self.specific_invite?(user, invitable, roles)
    end

private 

    def self.uberadmin? user
      user.invitations.uberadmin.count == 1
    end

    def self.specific_invite? user, invitable, roles
      invites = user.invitations.for_invitable(invitable.class.name, invitable.id)

      if invites.count > 0
        unless roles.nil?
          self.role_check invites.first, roles
        else
          true
        end
      end
    end

    def self.role_check invitation, roles
      if roles.respond_to? :map
        roles.include? invitation.role
      else
        invitation.role == roles
      end
    end

  end
end
