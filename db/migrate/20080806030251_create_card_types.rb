class CreateCardTypes < ActiveRecord::Migration
  def self.up
    create_table :card_types do |t|
      t.column :name, :string
      t.timestamps
    end
    CardType.init
        
    default_type = CardType.find_by_name("User Story")
    add_column :cards, :card_type_id, :integer, :default => default_type.id

    Card.all.each do |card|
      card.update_attributes({:card_type_id => default_type.id})
    end
    
  end

  def self.down
    remove_column :cards, :card_type_id
    drop_table :card_types
  end
  
end
