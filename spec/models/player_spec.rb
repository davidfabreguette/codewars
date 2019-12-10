RSpec.describe 'Player' do
  describe "#update" do
    context "when it's given the player's name 'Bob'" do
      it "sets player's name to 'Bob'" do
        CodeWars::Player.instance.update({
          name: "Bob"
          })
        expect(CodeWars::Player.instance.name).to eq('Bob')
      end
    end
  end
end
