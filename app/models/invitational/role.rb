module Invitational
  class Role
    attr_reader :name

    def self.[](role_name)
      Invitational.roles.invert[Invitational::Role.new(role_name)]
    end

    def initialize(name)
      @name = name
    end

    def display_name
      name.to_s.titleize
    end

    def ==(other)
      if other.respond_to?(:name)
        other = other.name
      end

      other == name
    end

    alias eql? ==

    def hash
      name.hash
    end


  end
end
