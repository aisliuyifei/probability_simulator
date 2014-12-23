class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.integer :level
      t.integer :strategy
      t.integer :bonus

      t.timestamps
    end
  end
end
