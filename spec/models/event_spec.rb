RSpec.describe 'Event' do
  before(:each) do
    launcher = get_launcher_with_no_output
  end

  let(:e0_event) {
    e0_event = CodeWars::DataStore.instance.events
      .select{|e| e.slug == "E0"}.first
  }
  let(:e1_event) {
    e1_event = CodeWars::DataStore.instance.events
      .select{|e| e.slug == "E1"}.first
  }
  let(:e03_event) {
    e3_event = CodeWars::DataStore.instance.events
      .select{|e| e.slug == "E03"}.first
  }
  let(:d0_decision) {
    CodeWars::DataStore.instance.decisions
      .select{|e| e.slug == "D0"}.first
  }
  let(:d1_decision) {
    CodeWars::DataStore.instance.decisions
      .select{|e| e.slug == "D1"}.first
  }
  let(:d2_decision) {
    CodeWars::DataStore.instance.decisions
      .select{|e| e.slug == "D2"}.first
  }
  let(:d3_decision) {
    CodeWars::DataStore.instance.decisions
      .select{|e| e.slug == "D3"}.first
  }
  let(:d0_decision_made) {
    d0_decision.made_at = Time.now
    d0_decision
  }
  let(:d1_decision_made) {
    d1_decision.made_at = Time.now
    d1_decision
  }
  let(:d2_decision_made) {
    d2_decision.made_at = Time.now
    d2_decision
  }
  let(:d3_decision_made) {
    d3_decision.made_at = Time.now
    d3_decision
  }

  describe "#decisions" do
    it "returns decision D0 for E0 event" do
      expect(e0_event.decisions.count).to be > 0
    end
  end

  describe "#available_decisions" do
    context "when D0 has already been made" do
      it "returns nothing !" do
        d0_decision_made
        expect(e0_event.available_decisions.count).to be == 0
      end
    end
  end

  describe "#made_decisions" do
    context "when D0 has already been made" do
      it "returns D0 decision" do
        d0_decision_made
        expect(e0_event.decisions_made.count).to be == 1
        expect(e0_event.decisions_made.first.slug).to eq("D0")
      end
    end
  end

  describe "#has_a_player_attribute_decision?" do
    context "as E0 event asks for player's name" do
      it "returns true" do
        expect(e0_event.has_a_player_attribute_decision?).to eq(true)
      end
    end
    context "as E1 event asks no player's attribute" do
      it "returns false" do
        expect(e1_event.has_a_player_attribute_decision?).to eq(false)
      end
    end
  end

  describe "#next_event_in_the_list" do
    context "As a E0 event" do
      it "returns E1 event" do
        next_event = CodeWars::DataStore.instance.events
          .select{|e| e.slug == "E01"}.first
        expect(e0_event.next_event_in_the_list).to eq(next_event)
      end
    end
  end

  describe "#static_next_event" do
    context "As a E1 event" do
      it "returns E5 event" do
        next_event = CodeWars::DataStore.instance.events
          .select{|e| e.slug == "E5"}.first
        expect(e1_event.static_next_event).to eq(next_event)
      end
    end
  end

  describe "#resolve_next_event" do
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
    context "As a E0 event" do
      context "that has a decision (D0) that has a player decision attribute" do
        it "returns E1 event (next event on the list)" do
          next_event = CodeWars::DataStore.instance.events
          .select{|e| e.slug == "E01"}.first
          expect(e0_event.next_event_in_the_list).to eq(next_event)
          expect(e0_event.resolve_next_event.indexed_at).to eq(e0_event.indexed_at + 1)
        end
      end
    end
    context "As a E1 event" do
      context "that has a decision (D1, D2, D3) and requires all decisions" do
        context "and only D1 decision is being made" do
          it "returns D1 next event E3 (as it's the latest made decision)" do
            expect(e1_event.resolve_next_event(d1_decision).slug).to eq("E3")
          end
        end
        context "and D1 decision has been made, and D2 decisions is being made" do
          it "returns D2 next event E2 (as it's the latest made decision)" do
            d1_decision_made
            expect(e1_event.resolve_next_event(d2_decision).slug).to eq("E2")
          end
        end
        context "and D1 and D2 decisions have been made, and D3 decision is being made" do
          it "returns D2 next event E3 (as it's the latest made decision)" do
            d1_decision_made
            d2_decision_made
            expect(e1_event.resolve_next_event(d3_decision).slug).to eq("E4")
          end
        end
        context "and D1, D2, and D3 decisions have been made" do
          it "returns E5 next event E4 (as it's E1 next event and all decisions have been made)" do
            d1_decision_made
            d2_decision_made
            d3_decision_made
            expect(e1_event.resolve_next_event.slug).to eq("E5")
          end
        end
      end
    end
    context "As a E17 boss event" do
      context "If the boss is beaten" do
        it "returns E21 event" do
          CodeWars::DarkCobol.instance.life_points = 0
          expect(e17_event.resolve_next_event.slug).to eq("E21")
        end
      end
    end
  end

  describe "#decisions_made" do
    context "As a E1 event (which requires all decisions)" do
      context "when D1 was made" do
        it "returns only D1 decision" do
          e1_event.decisions
            .select{|d|
               d.slug == "D1" ?
                 d.made_at = Time.now
               : d.made_at = nil
            }
          expect(e1_event.decisions_made.count).to eq(1)
        end
      end
    end
  end

  describe "#is_player_input_valid?" do
    context "as a E0 event (that has a player attribute)" do
      it "marks 'David' as a valid input" do
        expect(e0_event.is_player_input_valid?("David"))
          .to eq(true)
      end
      it "marks '' and nil as an valid input" do
        invalid_values = ["", nil]
        invalid_values.each do |invalid_value|
          expect(e0_event.is_player_input_valid?(invalid_value))
            .to eq(false)
        end
      end
    end
    context "as a E1 event (that has 3 decisions)" do
      it "marks 'David', nil, or any number higher than 3 as an invalid input" do
        invalid_values = ["David", nil, 4, 10]
        invalid_values.each do |invalid_value|
          expect(e1_event.is_player_input_valid?(invalid_value))
            .to eq(false)
        end
      end
    end
  end

  describe "#custom_label" do
    context "As a E03 Event that contains a #ME# meta field" do
      context "and the player's name is 'David'" do
        it "returns a label customized with 'David'" do
          CodeWars::Player.instance.name = "David"
          expect(e03_event.custom_label[/David/].size).to be > 0
        end
      end
    end
  end
end
