require "readline"
RSpec.describe "Launcher" do

  describe "#initialize" do
    it "launches welcome part !" do
      allow(Readline).to receive(:readline).and_return("David")
      event = CodeWars::DataStore.instance.events.first
      expect do
        CodeWars::Launcher.instance
      end
      .to output(/#{CodeWars::Launcher::WELCOME_TEXT}/).to_stdout

    end
  end

  describe "#start" do
    it "launches first event part !" do
      allow(Readline).to receive(:readline).and_return("David")
      event = CodeWars::DataStore.instance.events.first
      expect do
        CodeWars::Launcher.instance.start
      end
      .to output(/#{event.label}/).to_stdout
    end
  end

  describe "#welcome" do
    it "displays logo and welcome text" do
      logo = File.read("app/assets/logo.txt")
      launcher = nil

      # Disable console outputs temporarily
      RSpec::Mocks.with_temporary_scope do
        %w(puts print).each do |p_cmd|
          allow_any_instance_of(CodeWars::Launcher).to receive(p_cmd.to_sym)
          .and_return(true)
        end
        launcher = CodeWars::Launcher.instance
      end

      # Checks console output
      expect do
        launcher = launcher.welcome
      end.to output(/#{logo + CodeWars::Launcher::WELCOME_TEXT}/).to_stdout
    end
  end

  describe ".disable_auto_start!" do
    it "doesn't starts the game automatically" do
      expect do
        CodeWars::Launcher.disable_auto_start!
        CodeWars::Launcher.instance
      end.to output("").to_stdout
    end
  end
end
