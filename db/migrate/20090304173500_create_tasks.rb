class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :name
      t.column :position, :integer, :default => 0
      t.belongs_to :task_state, :null => false
      t.belongs_to :card
      t.belongs_to :user
      t.timestamps
    end
  end
 
  def self.down
    drop_table :tasks
  end
end
