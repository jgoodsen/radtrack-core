class ChangeOrderToListIndex < ActiveRecord::Migration
  def self.up
    rename_column :card_states, :order, :list_index
  end

  def self.down
    rename_column :card_states, :list_index, :order
  end
end
