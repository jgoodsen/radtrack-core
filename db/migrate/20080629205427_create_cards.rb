class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :status, :string
      t.column :point_estimate, :integer, :default => 0
      t.column :position, :integer, :default => 0
      t.belongs_to :project
      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
