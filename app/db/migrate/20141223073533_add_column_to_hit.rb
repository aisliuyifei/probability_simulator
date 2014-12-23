class AddColumnToHit < ActiveRecord::Migration
  def change
    add_column :hits,:count_six,:integer,:default=>0
    add_column :hits,:count_seven,:integer,:default=>0
    add_column :hits,:count_stone1,:integer,:default=>0
    add_column :hits,:count_stone2,:integer,:default=>0
    add_column :hits,:count_stone3,:integer,:default=>0
    add_column :steps,:prev_level,:integer
  end
end
