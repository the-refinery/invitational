class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include Invitational::InvitedTo

  invited_to :entity, :child
end
