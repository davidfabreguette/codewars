RSpec.describe 'Decision' do
  describe '#update_player=' do
    context "As the decision's attribute name is \"name\"" do
      context 'and the input value is "Bob"' do
        it "assigns player's name to 'Bob'" do
          decision = CodeWars::DataStore.instance
                                        .decisions.select { |d| d.slug == 'D0' }.first
          decision.update_player('Bob')
          expect(CodeWars::Player.instance.name).to eq('Bob')
        end
      end
    end
  end
  describe '#next_event' do
    context 'when D2 decision (next_event_slug is a String)' do
      it 'returns D2 next_event E2' do
        decision = CodeWars::DataStore.instance
                                      .decisions.select { |d| d.slug == 'D2' }.first
        expect(decision.next_event.slug).to eq('E2')
      end
    end

    context 'when D12 decision (next_event_slug is an Array)' do
      it 'returns a random value included in the array' do
        decision = CodeWars::DataStore.instance
                                      .decisions.select { |d| d.slug == 'D12' }.first
        expect(%w[E18 E19 E20]).to include(decision.next_event.slug)
      end
    end
  end
end
