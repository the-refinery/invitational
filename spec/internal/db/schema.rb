ActiveRecord::Schema.define do

  create_table :users, force: true do |t|
    t.string :email
    t.timestamps
  end

  create_table :entities, force: true do |t|
    t.string :name
    t.timestamps
  end

end
