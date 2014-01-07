class User < ActiveRecord::Base

  include ActiveModel::ForbiddenAttributesProtection
  has_many :invitations

end
