class Entity < ActiveRecord::Base
  attr_accessor :name

  has_many :invitations, :as => :invitable, class_name: "Invitational::Invitation"
end
