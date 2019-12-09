module CodeWars    
  ##
  # Base CodeWarsModel class
  # Can be used later on to add model global features ...
  class CodeWarsModel

    # Unique ID
    attr_accessor :id

    # Model slug
    # Allows to create models relationship through seed yml files
    attr_accessor :slug

    def initialize
      require 'securerandom'
      @id = SecureRandom.hex(8)
    end

    # Loads hash attributes to instance attributes
    # @param Hash data to load
    def load_attributes(data={})
      data.each do |key, value|
        if self.respond_to? "#{key}="
          self.send("#{key}=", value)
        end
      end
    end
  end
end
