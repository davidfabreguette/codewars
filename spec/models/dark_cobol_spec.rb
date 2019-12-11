RSpec.describe 'Player' do
  context "on initialize" do
    it "sets DarkCobol life points to 20" do
      expect(CodeWars::DarkCobol.instance.life_points).to eq(20)
    end
  end

  describe "#is_beaten?" do
    context "when #life_points = 0" do
      it "returns true" do
        CodeWars::DarkCobol.instance.life_points = 0
        expect(CodeWars::DarkCobol.instance.is_beaten?).to eq(true)
      end
    end
    context "when #life_points > 0" do
      it "returns true" do
        CodeWars::DarkCobol.instance.life_points = 13
        expect(CodeWars::DarkCobol.instance.is_beaten?).to eq(false)
      end
    end
  end

  describe "#attack!" do
    it "subscracts given life points to dark cobol life status" do
      attacks = [8,2,4]
      attacks.each do |attack|
        CodeWars::DarkCobol.instance.life_points = 20
        CodeWars::DarkCobol.instance.attack!(attack)
        expect(CodeWars::DarkCobol.instance.life_points).to eq(20 - attack)
      end
    end
  end
end
