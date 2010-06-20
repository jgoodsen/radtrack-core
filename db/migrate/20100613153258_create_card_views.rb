class CreateCardViews < ActiveRecord::Migration
  def self.up
    create_table :card_views do |t|
      t.belongs_to :project
      t.belongs_to :user
      t.string :name
      t.text :data
      t.timestamps
    end
  end

  def self.down
    drop_table :card_views
  end
end
