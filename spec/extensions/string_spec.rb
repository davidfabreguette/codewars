RSpec.describe "String" do
  describe "#underscore" do
    it "returns underscored string version" do
      expect("MySuperClassModel".underscore).to eq("my_super_class_model")
    end
  end
  describe "#pluralize" do
    it "returns a pluralized string version" do
      expect("event".pluralize).to eq("events")
    end
  end
end
