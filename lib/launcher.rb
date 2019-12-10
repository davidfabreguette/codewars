require 'yaml'
require 'awesome_print'
require 'rdoc'
require 'rspec'
require 'require_all'
require 'singleton'

module CodeWars
  class Launcher
    include Singleton

    WELCOME_TEXT = "Welcome to CodeWars Game !\n~~~"
    @@auto_start_enabled = true

    # Initilaze the app, gets the first event to
    # pass it on and get the game on !
    def initialize

      self.class.load_all_files

      CodeWars::DataStore.instance

      require 'readline'
      require "awesome_print"

      if @@auto_start_enabled
        start
      end
      #
      # ap "Before anything - enter your name :"
      # current_player = Readline.readline('❞ ', true)
      #
      # ap "Hey #{current_player} ! Let's get into this ..."

    end

    def self.disable_auto_start!
      @@auto_start_enabled = false
    end

    # Starts the game ! Shows the welcome section & launches the first event
    def start
      # Show the welcome section
      welcome

      # Get the first event
      event = CodeWars::DataStore.instance.events.first
      launch(event)
    end

    # Shows the game logo & welcome text
    def welcome
      logo = File.read("app/assets/logo.txt")
      print logo

      puts self.class::WELCOME_TEXT
    end

    # Launches the given event the the screen
    # @param Event event The event to be launched on screen
    # @return Event Next event to be launched on screen
    def launch(event)

      player_name = CodeWars::Player.instance.name || ""
      player_input = nil

      # Shows event label
      ap event.label

      # Search for any decisions choices to provide
      if (decisions = event.decisions).count > 0
        player_attribute_decision = nil

        if event.has_a_player_attribute_decision?
          player_attribute_decision = event.decisions.first
        else
          decisions.each_with_index do |decision, i|
            ap "#{i+1}/ #{decision.label}"
          end
        end

        if player_attribute_decision
          player_attribute_decision.update_player(player_input)
        end

        player_input = Readline.readline("#{player_name}❞ ", true)
      end

      if !event.has_a_player_attribute_decision? and
        player_input and player_input.size > 0

        # Find selected decision
        selected_decision = event.decisions[player_input.to_i]

        # Maked it as made
        selected_decision.made_at = Time.now
      end


      if next_event = event.resolve_next_event
        launch(next_event)
      else
        ap "This the end !"
      end

      # current_player = Readline.readline('❞ ', true)
    end

    private

    DIRS_TO_LOAD = %w(config extensions models)

    def self.load_all_files
      # # Make sure to require all module files
      DIRS_TO_LOAD.each do |dir_to_load|
        require_all "./app/#{dir_to_load}"
      end
    end
  end
end
