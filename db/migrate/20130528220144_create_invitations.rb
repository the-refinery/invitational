class CreateInvitations < ActiveRecord::Migration[4.2]
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :role
      t.references :invitable, polymorphic: true
      t.integer :user_id
      t.datetime :date_sent
      t.datetime :date_accepted
      t.string :claim_hash

      t.timestamps
    end

    add_index :invitations, :invitable_id
    add_index :invitations, :invitable_type
    add_index :invitations, :user_id
  end
end
