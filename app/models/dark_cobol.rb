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
    def beaten?
      life_points.zero?
    end

    # - @return [Integer] life_points
    def attack!(life_points_attack)
      self.life_points -= life_points_attack
      self.life_points = 0 if self.life_points.negative?
      life_points
    end
  end
end
