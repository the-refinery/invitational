class InvitationalGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  #argument :identity_class, type: :string, default: "User", banner: "Class name of identity (aka User) model"
  argument :roles, type: :array, default: ["none", "user", "admin"], banner: "List of Roles"

  def initializer_file
    @role_list = roles.map{|role| ":" + role}.join(", ")
    template "initializer.rb", "config/initializers/invitational.rb"
  end

  def ability_model
    template "ability.rb", "app/models/ability.rb"
  end

  def install_migration
    #rake("invitational_engine:install:migrations")
  end
end
