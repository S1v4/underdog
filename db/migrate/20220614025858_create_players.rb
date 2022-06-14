class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :sports do |t|
      t.string :name, null: false
    end

    create_table :players do |t|
      t.belongs_to :sport, null: false, index: true
      t.string :name_brief
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :position, null: false
      t.integer :age, null: false
      t.integer :average_position_age_diff
    end
  end
end
