class RemoveKeyFromCardState < ActiveRecord::Migration
  def self.up
    remove_column :card_states, :key
    rename_column :card_states, :human_readable, :name
  end

  def self.down
    add_column :card_states, :key, :string
    # rename_column :card_states, :name, :human_readable
  end
end
