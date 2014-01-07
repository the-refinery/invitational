class Entity < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  has_many :invitations, :as => :invitable

  has_many :children
end
