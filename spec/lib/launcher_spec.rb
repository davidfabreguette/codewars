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
        CodeWars::Launcher.disable_auto_start!
        launcher = CodeWars::Launcher.instance
      end

      # Checks console output
      expect do
        launcher = launcher.send(:welcome)
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

  describe "#launch" do

  end

  describe "#ask_player_to_make_decision" do
    let(:e0_event) {
      e0_event = CodeWars::DataStore.instance.events
        .select{|e| e.slug == "E0"}.first
    }
    let(:e1_event) {
      e1_event = CodeWars::DataStore.instance.events
        .select{|e| e.slug == "E1"}.first
    }
    before(:each) do
      CodeWars::Launcher.disable_auto_start!
      allow(Readline).to receive(:readline).and_return("David")
    end
    context "with E1 event" do
      it "shows decisions D1, D2, D3" do
        expect do
          CodeWars::Launcher
            .instance.send(:ask_player_to_make_decision, e1_event)
        end
        .to output(/(Observe the details)/).to_stdout
        expect do
          CodeWars::Launcher
            .instance.send(:ask_player_to_make_decision, e1_event)
        end
        .to output(/(Ask one of the custody that was present)/).to_stdout
        expect do
          CodeWars::Launcher
            .instance.send(:ask_player_to_make_decision, e1_event)
        end
        .to output(/(Search some details on the ground)/).to_stdout
      end
      it "asks player to make a choice" do
        expect do
          CodeWars::Launcher
            .instance.send(:ask_player_to_make_decision, e1_event)
        end
        .to output(/(Press the number of your choice below)/).to_stdout
      end
      it "prevents player from doing other choices than the ones allowed" do
        invalid_values = ["David", "5", "10"]
        invalid_values.each do |invalid_value|
          expect do
            allow(Readline).to receive(:readline).and_return(invalid_value)
            CodeWars::Launcher
            .instance.send(:ask_player_to_make_decision, e1_event)
          end
          .to output(/(Please choose a valid number)/).to_stdout
        end

        valid_values = [1,2,3].collect(&:to_s)
        valid_values.each do |valid_value|
          expect do
            allow(Readline).to receive(:readline).and_return(valid_value)
            CodeWars::Launcher
              .instance.send(:ask_player_to_make_decision, e1_event)
          end
          .not_to output(/(Please choose a valid number)/).to_stdout
        end
      end
    end

    context "with E0 event that asks for player's name" do
      it "stores player's name" do
        CodeWars::Launcher
          .instance.send(:ask_player_to_make_decision, e0_event)
        expect(CodeWars::Player.instance.name).to eq("David")
      end
    end
  end
end
