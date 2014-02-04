module Invitational
  class InvitationalError < StandardError; end

  class InvalidRoleError < InvitationalError; end
  class AlreadyInvitedError < InvitationalError; end

  class InvitationNotFoundError < InvitationalError; end
  class AlreadyClaimedError < InvitationalError; end
end
