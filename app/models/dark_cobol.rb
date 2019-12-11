require 'singleton'
module CodeWars
  ##
  # This class represents the boss
  class DarkCobol < CodeWarsModel
    include Singleton

    attr_accessor :life_points

    def initialize
      self.life_points ||= 20
    end

    # - @return [Boolean]
    def is_beaten?
      life_points == 0
    end

    # - @return [Integer] life_points
    def attack!(life_points_attack)
      self.life_points -= life_points_attack
      self.life_points = 0 if self.life_points < 0
      life_points
    end
  end
end
