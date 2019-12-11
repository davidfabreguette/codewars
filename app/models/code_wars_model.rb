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

    # Stores the index value of the event
    # to be able to get next event without going through the whole array
    attr_accessor :indexed_at

    def initialize
      require 'securerandom'
      @id = SecureRandom.hex(8)
    end

    # Loads hash attributes to instance attributes
    # - @param Hash data to load
    def load_attributes(data = {})
      data.each do |key, value|
        send("#{key}=", value) if respond_to? "#{key}="
      end
    end

    # Returns the data store instance name (underscored, pluralized, symoblized)
    # - @return [String]
    def data_store_name
      # We remove module prefix from the equation
      self.class.to_s.underscore.gsub(%r{^code_wars/}, '').pluralize.to_sym
    end

    # FIXME : Move this to an included shared "conern" class !
    # Make any "label field" customized with Player's name
    # based on meta field "#me#"
    # - @return [String]
    def custom_label
      return unless respond_to?(:label) && label

      label.gsub('#ME#', CodeWars::Player.instance.name || '')
    end
  end
end
