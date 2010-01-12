class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :admin,                     :boolean
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :persistence_token,  :string
      t.column :perishable_token,   :string,  :null => false, :default => ''
      t.column :login_count,        :integer, :null => false, :default => 0
      t.column :failed_login_count, :integer, :null => false, :default => 0
      t.column :current_login_at,   :datetime
      t.column :current_login_ip,   :string
      t.column :last_login_at,      :datetime
      t.column :last_login_ip,      :string
      t.column :crypted_password,          :string, :limit => 128, :null => false, :default => ""
      t.column :salt,                      :string, :limit => 128, :null => false, :default => ""
      
    end
    add_index :users, :login, :unique => true
    User.create_admin_user
  end

  def self.down
    drop_table "users"
  end
end
