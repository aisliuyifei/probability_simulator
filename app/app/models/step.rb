class Step < ActiveRecord::Base
  attr_accessible :current_bless, :current_level, :current_probability, :gold_using, :hit_id, :stone_level
  belongs_to :hit
end
