RSpec.describe 'CodeWarsModel' do
  context 'on initialize' do
    it 'has generates a default ID' do
      expect(CodeWars::CodeWarsModel.new.id).to be_truthy
    end
  end

  describe "#load_attributes" do
    context "when attributes are provided as a hash" do
      it "loads data into instance attributes" do
        instance = CodeWars::CodeWarsModel.new
        instance.load_attributes({id: 1234})
        expect(instance.id).to eq(1234)
      end
    end
  end

  describe "#data_store_name" do
    context "As a CodeWarsModel" do
      it "returns 'code_wars_models'" do
        expect(CodeWars::CodeWarsModel.new.data_store_name).to eq(:code_wars_models)
      end
    end
  end
end
