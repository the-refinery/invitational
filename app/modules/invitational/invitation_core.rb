module Invitational
  module InvitationCore
    extend ActiveSupport::Concern

    included do
      belongs_to :invitable, :polymorphic => true

      before_create :setup_hash

      validates :email,  :presence => true
      validates :role,  :presence => true
      validates :invitable,  :presence => true, :if => :standard_role?

      scope :uberadmin, lambda {
        where("invitable_id IS NULL AND role = 'uberadmin'")
      }

      scope :for_email, lambda {|email|
        where('email = ?', email)
      }

      scope :pending_for, lambda {|email|
        where('email = ? AND user_id IS NULL', email)
      }

      scope :for_claim_hash, lambda {|claim_hash|
        where('claim_hash = ?', claim_hash)
      }

      scope :for_invitable, lambda {|type, id|
        where('invitable_type = ? AND invitable_id = ?', type, id)
      }

      scope :by_role, lambda {|role|
        where('role = ?', role.to_s)
      }

      scope :pending, lambda { where('user_id IS NULL') }
      scope :claimed, lambda { where('user_id IS NOT NULL') }
    end

    module ClassMethods
      def claim claim_hash, user
        Invitational::ClaimsInvitation.for claim_hash, user
      end

      def claim_all_for user
        Invitational::ClaimsAllInvitations.for user
      end

      def invite_uberadmin target
        Invitational::CreatesUberAdminInvitation.for target
      end

    end

    def setup_hash
      self.date_sent = DateTime.now
      self.claim_hash = Digest::SHA1.hexdigest(email + date_sent.to_s)
    end

    def standard_role?
      role != :uberadmin
    end

    def role
      unless super.nil?
        super.to_sym
      end
    end

    def role=(value)
      super(value.to_sym)
      role
    end

    def role_title
      if uberadmin?
        "Uber Admin"
      else
        role.to_s.titleize
      end
    end

    def uberadmin?
      invitable.nil? == true && role == :uberadmin
    end

    def claimed?
      date_accepted.nil? == false
    end

    def unclaimed?
      !claimed?
    end
  end
end
