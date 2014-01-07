class Child < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :entity
end
