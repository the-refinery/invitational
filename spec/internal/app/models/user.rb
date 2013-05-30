class User < ActiveRecord::Base

  attr_accessor :email

  has_many :invitations, class_name: "Invitational::Invitation"

end
