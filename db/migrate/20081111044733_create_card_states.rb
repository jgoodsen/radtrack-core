class CreateCardStates < ActiveRecord::Migration
  def self.up

    create_table :card_states do |t|
      t.integer :order, :default => 1
      t.string :key, :null => false
      t.string :human_readable, :null => false
      t.belongs_to :project
      t.timestamps
    end
    
    add_column :cards, :card_state_id, :integer
    
  end

  def self.down
    remove_column :cards, :card_state_id
    drop_table :card_states
  end
end
