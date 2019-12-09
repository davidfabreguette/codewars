require 'yaml'
require 'awesome_print'
require 'rdoc'
require 'rspec'
require 'require_all'

module CodeWars
  class Launcher

    DIRS_TO_LOAD = %w(config extensions models)

    def self.load_all_files
      # # Make sure to require all module files
      DIRS_TO_LOAD.each do |dir_to_load|
        require_all "./app/#{dir_to_load}"
      end
    end

    def initialize

      self.class.load_all_files

      CodeWars::DataStore.instance.seed

      puts "what ??"
      require 'readline'
      require "awesome_print"

      logo = File.read("app/assets/logo.txt")
      print logo

      ap "Welcome to CodeWars Game !"
      ap "---"
      ap "Before anything - enter your name :"
      current_player = Readline.readline('❞ ', true)

      ap "Hey #{current_player} ! Let's get into this ..."

    end
  end
end
