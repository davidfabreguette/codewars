RSpec.describe 'Decision' do
  describe "#update_player=" do
    context "As the decision's attribute name is \"name\"" do
      context "and the input value is \"Bob\"" do
        it "assigns player's name to 'Bob'" do
          decision = CodeWars::DataStore.instance
            .decisions.select{|d| d.slug == "D0"}.first
          decision.update_player("Bob")
          expect(CodeWars::Player.instance.name).to eq("Bob")
        end
      end
    end
  end
  describe "#next_event" do
    context "when D2 decision" do
      it "returns D2 next_event E3" do
        decision = CodeWars::DataStore.instance
          .decisions.select{|d| d.slug == "D2"}.first
        next_event = CodeWars::DataStore.instance
          .events.select{|d| d.slug == "E3"}.first
        expect(decision.next_event).to eq(next_event)
      end
    end
  end
end
