module Invitational
  module InvitedTo

    def invited_to *args
      args.each do |entity|
        relation = entity.to_s.pluralize.to_sym
        type = entity.to_s.camelize

        has_many relation, through: :invitations, source: :invitable, source_type: type
      end
    end

  end
end
