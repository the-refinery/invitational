class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  extend Invitational::InvitedTo

  has_many :invitations

  invited_to :entity, :child
end
