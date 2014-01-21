class InvitationalGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :identity_class, type: :string, default: "User", banner: "Class name of identity model (e.g. User)"

  def add_to_gemfile
    gem "cancan"
  end

  def invitation_model
    @identity_class = identity_class.gsub(/\,/,"").camelize

    if  @identity_class != "User"
      @custom_user_class = ", :class_name => '#{@identity_class}'"
    else
      @custom_user_class = ""
    end

    template "invitation.rb", "app/models/invitation.rb"
  end

  def ability_model
    @identity_model = @identity_class.underscore
    template "ability.rb", "app/models/ability.rb"
  end

  def link_to_identity_model
    path = "app/models/#{@identity_model}.rb"
    inject_into_class path, @identity_class.constantize, "  has_many :invitations\n"
  end

  def install_migration
    rake("invitational_engine:install:migrations")
  end

end
