RSpec.describe "Hash" do
  describe "#deep_symbolize_keys" do
    it "returns a new array with nested hash symbolized keys" do
      array = [{"code_wars_are_fun": "yep"}]
      expect(array.deep_symbolize_keys).not_to equal(array) # Checks if array is a new object
      expect(array.deep_symbolize_keys[0][:code_wars_are_fun]).to eq("yep")
    end
  end
end
