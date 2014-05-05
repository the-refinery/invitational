class Grandparent < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::AcceptsInvitationAs

  has_many :entities

  accepts_invitation_as :admin
end

