module Invitational
  module Generators
    class EntityGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :identity_class, type: :string, default: "User", banner: "Class name of identity model (e.g. User)"
      argument :roles, type: :array, default: ["none", "user", "admin"], banner: "List of Roles"
    end
  end
end
