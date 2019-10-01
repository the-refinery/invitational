class Invitation < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::InvitationCore

  belongs_to :user, optional: true

  accepts_system_roles_as :employer, :consultant


end
