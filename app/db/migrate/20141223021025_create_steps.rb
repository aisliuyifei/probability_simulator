class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :hit_id
      t.integer :current_level
      t.integer :current_bless
      t.integer :current_probability
      t.integer :stone_level
      t.integer :gold_using

      t.timestamps
    end
  end
end
