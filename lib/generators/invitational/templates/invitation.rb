class Invitation < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::InvitationCore

end
