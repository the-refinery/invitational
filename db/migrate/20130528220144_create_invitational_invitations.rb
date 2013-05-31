class CreateInvitationalInvitations < ActiveRecord::Migration
  def change
    create_table :invitational_invitations do |t|
      t.string :email
      t.integer :role
      t.references :invitable, polymorphic: true
      t.integer :user_id
      t.datetime :date_sent
      t.datetime :date_accepted
      t.string :claim_hash

      t.timestamps
    end

    add_index :invitational_invitations, :invitable_id
    add_index :invitational_invitations, :invitable_type
    add_index :invitational_invitations, :user_id
  end
end
