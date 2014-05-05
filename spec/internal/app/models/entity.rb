class Entity < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::AcceptsInvitationAs

  belongs_to :grandparent
  has_many :children

  accepts_invitation_as :admin, :user
end
