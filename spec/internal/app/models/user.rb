class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection
  has_many :invitations, class_name: "Invitational::Invitation"

end
