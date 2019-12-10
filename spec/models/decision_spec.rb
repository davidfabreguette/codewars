RSpec.describe 'Decision' do
  describe "#current_player_input_attribute=" do
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
end
