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
  let(:d1_decision) {
    CodeWars::DataStore.instance.decisions
      .select{|e| e.slug == "D1"}.first
  }
  let(:d1_decision_made) {
    d1_decision.was_made = true
  }

  describe "#decisions" do
    it "returns decision D0 for E0 event" do
      expect(e0_event.decisions.count).to be > 0
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

  describe "#raw_next_event" do
    context "As a E0 event" do
      it "returns E1 event" do
        next_event = CodeWars::DataStore.instance.events
          .select{|e| e.slug == "E01"}.first
        expect(e0_event.raw_next_event).to eq(next_event)
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
    context "As a E0 event" do
      context "that has a decision (D0) that has a player decision attribute" do
        it "returns E1 event (next event on the list)" do
          next_event = CodeWars::DataStore.instance.events
          .select{|e| e.slug == "E01"}.first
          expect(e0_event.raw_next_event).to eq(next_event)
          expect(e0_event.resolve_next_event.indexed_at).to eq(e0_event.indexed_at + 1)
        end
      end
    end
    context "As a E1 event" do
      context "that has a decision (D1, D2, D3) and requires all decisions" do
        context "and only D1 decision has been made so far" do
          it "returns D1 next event (as it's the latest made decision)" do
            #TODO :
          end
        end
        context "and D1, and D2 decisions have been made so far" do
          it "returns D2 next event (as it's the latest made decision)" do
            #TODO :
          end
        end
        context "and D1, D2, and D3 decisions have been made so far" do
          it "returns E5 next event (as it's E1 next event and all decisions have been made)" do
            #TODO :
          end
        end
      end
    end
  end

  describe "#decisions_made" do
    context "As a E1 event (which requires all decisions)" do
      context "when D1 and D2 were made" do
        it "returns only D1 and D2 decisions" do
          d1_and_d2_decisions = e1_event.decisions
          .select{|d| %w(D1 D2).include?(d.slug)}
          d1_and_d2_decisions.each do |d|
            d.made_at = Time.now
          end
          e0_event = CodeWars::DataStore.instance.events.select{|e| e.slug == "E1"}.first
          expect(e0_event.decisions_made.count).to eq(2)
        end
      end
    end
  end
end
