class Hit < ActiveRecord::Base
  attr_accessible :bonus, :level, :strategy
  has_many :steps
  attr_accessor :bless
  
  def prob(level)
    probs = {
      11=>9,
      10=>11,
      9=>12,
      8=>23,
      7=>28,
      6=>33,
      5=>38,
      4=>54,
      3=>100,
      2=>100,
      1=>100
    }
    return probs[level]+self.bonus
  end
  
  def self.stone_level(level)
    return 1 if level<3
    return 2 if level<7
    return 3
  end
  
  def self.bless_for_level(level)
    return 2<<(level-1)
  end
  
  
  def simulate
   
    self.bless=0
    total_bless={
      9=>4500,
      10=>6000,
      11=>9000
      }[self.level]
    current_level = self.level
    target_level = self.level+1
     puts "#{current_level}->#{target_level}"
    while current_level<target_level
      #消耗
      step = Step.new
      step.hit_id = self.id
      step.prev_level = current_level
      step.stone_level = Hit.stone_level(current_level)
      if step.stone_level==1
        self.count_stone1 +=1
      elsif step.stone_level==2
        self.count_stone2 +=1
      else
        self.count_stone3 +=1
      end
      prob = self.prob(current_level)
      rand = Random.rand(100)
      
      if rand<=prob
        current_level+=1
      else
        self.bless += Hit.bless_for_level(current_level)
        if self.bless>=total_bless
          current_level = target_level
        else
          if ((self.strategy==1||self.strategy==3) && current_level==5)
            self.count_six+=1
          elsif ((self.strategy==2||self.strategy==3) && current_level==6)
            self.count_seven+=1
          else  
            current_level-=2
          end
        end
          
      end
      step.current_level = current_level
      step.current_bless = self.bless
      step.save!
      self.save!
      
    end
  end
  
  def cost
    35*self.count_seven+self.count_six*25+5*self.count_stone1+self.count_stone2*20+self.count_stone3*60
  end
  
  
  def strategy_name
    ["策略1:不保护","策略2:+6保护","策略3:+7保护","策略4:+6+7保护"][self.strategy]
  end
  
  
  def desc
    str=""
    str+="<br\>小计：初级#{self.count_stone1}，中级：#{self.count_stone2}高级：#{self.count_stone3}"
    str+=",+6保护：#{self.count_six},+6保护：#{self.count_seven}"
    str+="<br\>约合钻/券:#{self.cost}"
    str+="<br\>"
    self.steps.each do |x|
      if x.prev_level>=x.current_level
        str+="<br\>#{x.prev_level}->#{x.current_level} ,当前祝福:#{x.current_bless}"
      else
        str+="<br\>#{x.prev_level}->#{x.current_level}"
      end
    end

    return str
  end
  
end
