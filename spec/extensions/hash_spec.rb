RSpec.describe "Hash" do
  describe "#deep_symbolize_keys" do
    it "returns a new hash with symbolized keys" do
      hash = {"code_wars_are_fun": "yep"}
      expect(hash.deep_symbolize_keys).not_to equal(hash) # Checks if hash is a new object
      expect(hash.deep_symbolize_keys[:code_wars_are_fun]).to eq("yep")
    end
  end
end
