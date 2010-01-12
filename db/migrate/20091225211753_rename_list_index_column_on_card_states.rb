class RenameListIndexColumnOnCardStates < ActiveRecord::Migration
  def self.up
    rename_column :card_states, :list_index, :position
  end

  def self.down
    rename_column :card_states, :position, :list_index
  end
end
