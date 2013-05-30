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

def invite_user user, entity, role
  invitation = Invitable::Invitation.new(email: user.email, invitable: entity, role: role, user: user)
  invitation.save

  invitation
end

