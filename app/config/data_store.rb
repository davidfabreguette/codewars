require 'singleton'
require 'yaml'

module CodeWars
  ##
  # Main CodeWars Data Store
  # Data is loaded in memory through data yml files in /data folder
  class DataStore
    include Singleton

    # Main Data Hash of CodeWars Instances
    attr_reader :data

    # Models seeded through YML files
    SEEDED_MODELS = %w(Event Decision)

    def initialize
      seed
      define_models_getters
    end

    # Sets up models getters dynamically (#events, #decisions)
    def define_models_getters
      self.class::SEEDED_MODELS.each do |seed_model|
        seed_model_name = seed_model.underscore.pluralize.to_sym
        define_singleton_method(seed_model_name) do
          @data[seed_model_name]
        end
      end
    end

    # Configure database
    # def configure(database_file_name="code_wars.db")
    #   # Open a database
    #   @db = SQLite3::Database.new "./#{database_file_name}.db"
    # end

    # Represents the current player instance
    # @return Player
    def current_player
      @player ||= Player.new
    end

    private

    # Loads data yml files in memory in data array attribute
    # @return [CodeWarsModel]
    def seed
      @data = {}

      SEEDED_MODELS.each do |model_name|

        pluralized_model_name = model_name.underscore + "s"

        # Load data as an array of objects
        models_data = YAML.load(File.read("app/data/#{pluralized_model_name}.yml")).deep_symbolize_keys

        # Constantize model klass
        model_klass = Class.const_get("CodeWars::#{model_name}")

        # Map models data to new Instances
        models_data.each do |model_data|
          model = model_klass.new

          model.load_attributes(model_data||{})

          # Push to DataStore memory

          @data[pluralized_model_name.to_sym] ||= []
          @data[pluralized_model_name.to_sym] << model
        end
      end
    end
  end
end
