require "readline"
RSpec.describe "Launcher" do
  let(:e0_event) {
    e0_event = CodeWars::DataStore.instance.events
      .select{|e| e.slug == "E0"}.first
  }
  let(:e1_event) {
    e1_event = CodeWars::DataStore.instance.events
      .select{|e| e.slug == "E1"}.first
  }
  let(:e17_event) {
    e17_event = CodeWars::DataStore.instance.events
      .select{|e| e.slug == "E17"}.first
  }
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
      disable_puts_and_prints

      CodeWars::Launcher.disable_auto_start!
      launcher = CodeWars::Launcher.instance

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

  describe "#ask_player_to_make_decision" do
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

  describe "display_error_messages" do
    before(:all) do
      CodeWars::Launcher.disable_auto_start!
    end
    context "when attempts are exceeded" do
      it "shows 'game is over !'" do
        expect do
          CodeWars::Launcher.instance
            .send(:display_error_messages, true, false)
        end.to output(/Alright - game is over |o| .../).to_stdout
      end
    end
    context "when attempts aren't exceeded" do
      context "and this is numbered player input" do
        it "shows 'Please choose a valid number'" do
          expect do
            CodeWars::Launcher.instance
              .send(:display_error_messages, false, true)
          end.to output(/Alright - game is over |o| .../).to_stdout
        end
      end
      context "and this is not a numbered player input" do
        it "shows 'Please choose a valid number'" do
          expect do
            CodeWars::Launcher.instance
              .send(:display_error_messages, false, false)
          end.to output(/Please enter something !/).to_stdout
        end
      end
    end
  end

  describe "#launch" do

    before(:all) do
      CodeWars::Launcher.disable_auto_start!
    end

    before(:each) do
      # Stub Readline section
      allow_any_instance_of(CodeWars::Launcher)
        .to receive(:ask_player_to_make_decision)
        .and_return("")

      # Stub recursive section (as #resolve_next_event is already tested)
      allow_any_instance_of(CodeWars::Event)
        .to receive(:resolve_next_event)
        .and_return(nil)
    end

    # IT SHOWS EVENT LABEL
    context "as it launches the E0 event asking for Player's name" do
      it "shows the event label" do
        expect do
          CodeWars::Launcher.instance.launch(e0_event)
        end.to output(/#{e0_event.custom_label}/).to_stdout
      end
    end

    context "as it lauches the E1 event, and all decisions have been made" do
      it "doesn't show the E1 event label again" do
        expect do
          e1_event.available_decisions
            .each{|d| d.made_at = Time.now }
          CodeWars::Launcher.instance.launch(e1_event)
        end.not_to output(/#{e1_event.custom_label}/).to_stdout
      end
    end

    it "defines 'from' decision as 'made'" do
      disable_puts_and_prints
      d = e1_event.available_decisions[0]
      CodeWars::Launcher.instance.launch(e1_event, d)
      expect(d.made_at).not_to eq(nil)
    end

    it "sends to #ask_player_to_make_decision the event" do
      disable_puts_and_prints
      CodeWars::Launcher.instance.launch(e1_event)
      expect(CodeWars::Launcher.instance)
        .to have_received(:ask_player_to_make_decision)
        .with(e1_event)
    end

    it "ends the game if there's no decision and input is invalid" do
      allow(CodeWars::Launcher.instance)
        .to receive(:ask_player_to_make_decision)
        .and_return([nil, true])
      expect do
        CodeWars::Launcher.instance.launch(e1_event)
      end.to output(/Bye bye Jedi !/).to_stdout
    end

    it "launches given next event by #resolve_next_event" do
      d0_decision = e0_event.available_decisions[0]
      allow(e0_event)
        .to receive(:resolve_next_event)
        .and_return(e1_event)

      allow(CodeWars::Launcher.instance)
        .to receive(:ask_player_to_make_decision)
        .and_return([d0_decision])

      # We simply can make sure of that by checking label outputs
      # of next e1_event
      expect do
        CodeWars::Launcher.instance.launch(e0_event)
      end.to output(/#{e1_event.label}/).to_stdout
    end

    context "in boss fight mode" do
      after(:all) do
        # As it's an instance, make sure life points get back to original state
        CodeWars::DarkCobol.instance.life_points = 20
      end
      context "when event requires_boss_beaten" do
        context "and chosen decision has an attack set" do
          it "attacks the boss with the selected dession attack" do
            disable_puts_and_prints
            d13_decision = e17_event.available_decisions
              .select{|d| d.slug == "D13"}.first
            allow(CodeWars::Launcher.instance)
              .to receive(:ask_player_to_make_decision)
              .and_return([d13_decision, nil])
            expect(CodeWars::DarkCobol.instance)
              .to receive(:attack!)
              .with(5)
            CodeWars::Launcher.instance.launch(e17_event)
          end
          it "shows the boss life status" do
            CodeWars::DarkCobol.instance.life_points = 20
            d13_decision = e17_event.available_decisions
              .select{|d| d.slug == "D13"}.first
            allow(CodeWars::Launcher.instance)
              .to receive(:ask_player_to_make_decision)
              .and_return([d13_decision, nil])
            expected_output= "> Dark Cobol life status : (15/20)"
            regex = Regexp.new(Regexp.escape(expected_output))
            expect do
              CodeWars::Launcher.instance.launch(e17_event)
            end.to output(regex).to_stdout
          end
        end
      end
      it "makes sure the selected decision is not getting made by next recursive cycle" do
        disable_puts_and_prints
        CodeWars::DarkCobol.instance.life_points = 20
        d13_decision = e17_event.available_decisions
          .select{|d| d.slug == "D13"}.first
        allow(CodeWars::Launcher.instance)
          .to receive(:ask_player_to_make_decision)
          .and_return([d13_decision, nil])
        CodeWars::Launcher.instance.launch(e17_event)
        expect(d13_decision.made_at).to eq(nil)
      end
   end
  end
end
