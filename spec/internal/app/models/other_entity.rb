class OtherEntity < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::AcceptsInvitationAs

  accepts_invitation_as :other_role
end

