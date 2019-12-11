require 'yaml'
require 'colorize'
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

      if @@auto_start_enabled
        start
      end
    end

    # Prevent from launching the game automatically
    # Usefull for tests suite !
    # - @return [Boolean]
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

    # Launches the events on the screen
    # Recursive method accepting two params
    # - @param [Event] event The event to be launched on screen
    # - @param [Decision] from_decision The decision that orginaly launched the event
    # - @return [Event] Next event to be launched on screen
    def launch(event, from_decision=nil)

      end_game_label = "Bye bye Jedi !"

      # Shows event label
      # unless this is a "require all decisions" event and
      # all decisions have already been chosen !
      unless event.available_decisions.count == 0 and
        event.requires_all_decisions
        puts ".".colorize(:red)
        puts event.custom_label.colorize(:yellow)
      end

      # Mark the decision as "made"
      # We consider the decision as "made" once the event it leads to
      # has been displayed on screen
      if from_decision
        from_decision.made_at = Time.now
      end

      selected_decision, input_was_invalid = ask_player_to_make_decision(event)

      if !selected_decision and input_was_invalid
        puts end_game_label.colorize(:yellow)
        return
      end

      if event.requires_boss_beaten and
        selected_decision.life_points and selected_decision.life_points.to_i > 0

        CodeWars::DarkCobol.instance.attack!(selected_decision.life_points)
        puts "> Dark Cobol life status : (#{CodeWars::DarkCobol.instance.life_points}/20)"
      end

      if next_event = event.resolve_next_event(selected_decision)
        if event.requires_boss_beaten
          selected_decision = nil # we prevent sending decision back in to prevent it from being "made"
        end
        launch(next_event, selected_decision)
      else
        puts end_game_label.colorize(:yellow)
      end
    end

    private

    # Shows the game logo & welcome text
    def welcome
      logo = File.read("app/assets/logo.txt")
      print logo

      puts self.class::WELCOME_TEXT
    end

    # This methods :
    # - shows the player available decisions
    # - asks the player to choose the decision
    # - (and prevents from entering something else !)
    # - stores any player attribute if applyable
    # @param [Event] event from which decisions are pulled off
    # @return [Decision, Boolean] any chosen decision by player
    def ask_player_to_make_decision(event)
      selected_decision = nil
      player_name = CodeWars::Player.instance.name || ""
      player_input_is_valid = false

      # Extracts available (non-already made) decisions
      available_decisions = event.available_decisions

      # Show decisions choices to player
      if available_decisions.count > 0
        player_attribute_decision = nil # store as a cache value any attribute decision

        # If this is "player attribute" decision
        # Then no need to loop over
        if event.has_a_player_attribute_decision?
          player_attribute_decision = event.decisions.first
        else
          available_decisions.each_with_index do |decision, i|
            puts "#{i+1}/ #{decision.custom_label}"
          end
        end

        unless event.has_a_player_attribute_decision?
          puts "--> Press the number of your choice below :".colorize(:yellow)
        end

        max_attempts = 3 # we allow only 3 attempts - the game will stop if no decision is made
        attempts = 0
        while !player_input_is_valid and attempts < max_attempts do
          player_input = Readline.readline("❞ >", true)
          attempts += 1
          player_input_is_valid = event.is_player_input_valid?(player_input)

          if !player_input_is_valid
            display_error_messages((attempts == max_attempts),
              !event.has_a_player_attribute_decision?)
          end
        end

        if player_input_is_valid
          puts "|"
          puts "|"
          puts "|"
          puts "->"
          if player_attribute_decision
            player_attribute_decision.update_player(player_input)
          end

          # Find selected decision
          selected_decision = available_decisions[player_input.to_i - 1]
        end

        [selected_decision, player_input_is_valid]
      end

    end

    # Shows display error messages
    # - @param [Boolean] has_exceeded_attempts
    # - @param [Boolean] is_a_numbered_input
    def display_error_messages(has_exceeded_attempts, is_a_numbered_input)
      if !has_exceeded_attempts
        if is_a_numbered_input
          puts "Please choose a valid number"
        else
          puts "Please enter something !"
        end
      else
        puts "Alright - game is over |o| ..."
      end
    end

    DIRS_TO_LOAD = %w(config extensions models)

    # Loads all needed files for the game
    def self.load_all_files
      DIRS_TO_LOAD.each do |dir_to_load|
        require_all "./app/#{dir_to_load}"
      end
    end
  end
end
