class Entity < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::AcceptsInvitationAs

  has_many :children

  accepts_invitation_as :admin, :user
end
