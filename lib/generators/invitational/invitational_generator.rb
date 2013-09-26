class InvitationalGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :identity_class, type: :string, default: "User", banner: "Class name of identity (aka User) model"
  argument :roles, type: :array, default: ["none", "user", "admin"], banner: "List of Roles"

  def initializer_file
    @identity_class = identity_class.gsub(/\,/,"").camelize
    @role_list = roles.map{|role| ":" + role.gsub(/\,/,"")}.join(", ")
    template "initializer.rb", "config/initializers/invitational.rb"
  end

  def ability_model
    @identity_model = @identity_class.underscore
    template "ability.rb", "app/models/ability.rb"
  end

  def link_to_identity_model
    path = "app/models/#{@identity_model}.rb"
    inject_into_class path, @identity_class.constantize, "  has_many :invitations, class_name: \"Invitational::Invitation\"\n"
  end

  def install_migration
    rake("invitational_engine:install:migrations")
  end

end
