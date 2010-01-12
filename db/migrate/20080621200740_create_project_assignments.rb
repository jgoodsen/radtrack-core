class CreateProjectAssignments < ActiveRecord::Migration
  def self.up
    create_table :project_assignments do |t|
      t.column :user_id, :integer
      t.column :project_id, :integer
    end
  end

  def self.down
    drop_table :project_assignments
  end
end
