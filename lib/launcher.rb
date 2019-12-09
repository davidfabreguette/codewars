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

    # Initilaze the app, gets the first event to
    # pass it on and get the game on !
    def initialize

      self.class.load_all_files

      CodeWars::DataStore.instance

      require 'readline'
      require "awesome_print"

      start

      #
      # ap "Before anything - enter your name :"
      # current_player = Readline.readline('❞ ', true)
      #
      # ap "Hey #{current_player} ! Let's get into this ..."

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
      ap event.label
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
