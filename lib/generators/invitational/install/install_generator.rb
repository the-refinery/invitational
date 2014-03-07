module Invitational
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :identity_class, type: :string, default: "User", banner: "Class name of identity model (e.g. User)"

      def invitation_model
        @identity_class = identity_class.gsub(/\,/,"").camelize

        if  @identity_class != "User"
          @custom_user_class = ", :class_name => '#{@identity_class}'"
        else
          @custom_user_class = ""
        end

        template "invitation.rb", "app/models/invitation.rb"
      end

      def add_to_gemfile
        gem "cancancan"
      end

      def ability_model
        @identity_model = @identity_class.underscore
        template "ability.rb", "app/models/ability.rb"
      end

      def link_to_identity_model
        path = "app/models/#{@identity_model}.rb"
        content = "  include Invitational::InvitedTo\n"

        inject_into_class path, @identity_class.constantize, content
      end

      def install_migration
        rake("invitational_engine:install:migrations")
      end

    end

  end
end
