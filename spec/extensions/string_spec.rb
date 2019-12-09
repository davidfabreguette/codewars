RSpec.describe "String" do
  describe "#underscore" do
    it "returns underscored string version" do
      expect("MySuperClassModel".underscore).to eq("my_super_class_model")
    end
  end
end
