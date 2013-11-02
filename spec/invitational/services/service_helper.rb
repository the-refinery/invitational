def setup_user email
  user = User.new(email: email)
  user.save

  user
end

def setup_entity name
  entity = Entity.new(name: name)
  entity.save

  entity
end

def setup_child name, entity
  child = Child.new(name: name)
  child.save

  entity.children << child

  child
end

def invite_by_email email, entity, role
  invitation = Invitational::Invitation.new(email: email, invitable: entity, role: Invitational::Role[role])
  invitation.save

  invitation
end

def invite_user user, entity, role
  invitation = Invitational::Invitation.new(email: user.email, invitable: entity, role: Invitational::Role[role], user: user)
  invitation.save

  invitation
end

def invite_uber_admin user
  invitation = Invitational::Invitation.new(email: user.email, role: Invitational::Role[:uberadmin], user: user)
  invitation.save

  invitation
end
