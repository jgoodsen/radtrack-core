class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.string :name
      t.text :card_positions_json
      t.belongs_to :project
      t.timestamps
    end
  end

  def self.down
    drop_table :boards
  end
end
