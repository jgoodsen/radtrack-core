class AddAssociationBetweenUserAndCard < ActiveRecord::Migration
  def self.up
    add_column :cards, :user_id, :integer
    add_index :cards, :user_id
  end

  def self.down
    remove_index :cards, :user_id    
    remove_column :cards, :user_id
  end
end
