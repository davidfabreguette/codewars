RSpec.describe 'DataStore' do

  let(:e0_event) {
    e0_event = CodeWars::DataStore.instance.events
      .select{|e| e.slug == "E0"}.first
  }

  context 'during initialization' do
    it 'has seeded models set' do
      expect(CodeWars::DataStore::SEEDED_MODELS).to eq(%w(Event Decision))
    end
    describe "#define_models_getters" do
      it "defines seed models getters methods" do
        CodeWars::DataStore::SEEDED_MODELS.each do |seed_model|
          expect(CodeWars::DataStore.instance).to respond_to(seed_model.underscore.pluralize.to_sym)
        end
      end
      it "seed models getters returns seed data" do
        CodeWars::DataStore::SEEDED_MODELS.each do |seed_model|
          seed_model_name = seed_model.underscore.pluralize.to_sym
          expect(CodeWars::DataStore.instance.send(seed_model_name).count)
            .to be > 0
        end
      end
    end
  end

  context 'as it seeds data in from yml files' do
    it 'contains all imported data in memory' do
      expect(CodeWars::DataStore.instance.data.count).to be > 0
      expect(CodeWars::DataStore.instance.data[:events].count).to be > 0
    end
  end

  describe "#find_in_store" do
    it 'finds in store event E0' do
      expect(CodeWars::DataStore.instance.find_in_store(e0_event))
    end
  end
  
  describe "#update_in_store" do
    it 'updates in store event E0' do
      e0_event.label = "oups...I did it again !"
      expect(CodeWars::DataStore.instance.find_in_store(e0_event).label)
        .to eq("oups...I did it again !")
    end
  end
end
