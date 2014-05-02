class SystemThing < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::AcceptsInvitationAs

end
