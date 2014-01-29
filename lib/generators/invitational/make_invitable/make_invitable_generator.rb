module Invitational
  module Generators
    class MakeInvitableGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :entity_class, type: :string, banner: "Class name of entity class to which users will be invited"
      argument :roles, type: :array, default: ["role"], banner: "List of Valid Roles"

      def add_invitational_reference
        @entity_class = entity_class.gsub(/\,/,"").camelize
        @entity_model = @entity_class.underscore
        @path = "app/models/#{@entity_model}.rb"
        @role_list = roles.map{|role| ":" + role.gsub(/\,/,"")}.join(", ")

        content = "  include Invitational::AcceptsInvitationAs\n  accepts_invitation_as #{@role_list}\n"

        inject_into_class @path, @entity_class.constantize, content
      end

    end
  end
end
