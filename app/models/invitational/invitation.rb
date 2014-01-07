module Invitational
  class Invitation < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    include InvitationCore

  end
end

