ActiveRecord::Schema.define do

  create_table :users, force: true do |t|
    t.string :email
    t.timestamps
  end

  create_table :entities, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :children, force: true do |t|
    t.string :name
    t.integer :entity_id
    t.timestamps
  end

  create_table :other_entities, force: true do |t|
    t.string :name
    t.timestamps
  end
  
  create_table :system_things, force: true do |t|
    t.string :name
    t.timestamps
  end

end
