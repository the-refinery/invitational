class InvitationalGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :roles, type: :array, default: [":none", ":user", ":admin"], banner: "List of Roles"

  def initializer_file
    @role_list = roles.join(", ")
    template "initializer.rb", "config/initializers/invitational.rb"
  end

  def install_migration
    rake("invitational_engine:install:migrations")
  end
end
