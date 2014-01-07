require "invitational/engine"

module Invitational

  mattr_accessor :user_class
  @@user_class = "User"

  mattr_reader :roles
  @@roles = {}

  def self.define_roles(*args)
    @@roles[-1] = Invitational::Role.new(:uberadmin)
    args.each_with_index do |role,idx|
      @@roles[idx] = Invitational::Role.new(role)
    end
  end

end
