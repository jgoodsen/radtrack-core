class AddWipToCardState < ActiveRecord::Migration
  def self.up
    add_column :card_states, :wip_limit, :integer, :default => 0
  end

  def self.down
    remove_column :card_states, :wip_limit
  end
end
