require "singleton"
module CodeWars
  ##
  # This class represents the player
  class Player < CodeWarsModel
    include Singleton

    # Name
    attr_accessor :name

    # This methods sets attributes based on given hash attributes
    # - @param Hash attributes
    def update(attributes)
      attributes.each do |attribute, value|
        if self.respond_to? attribute
          CodeWars::Player.instance.send("#{attribute}=", value)
        end
      end
    end

  end
end
