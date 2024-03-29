RSpec.describe 'DataStore' do
  let(:e0_event) do
    CodeWars::DataStore.instance.events.select { |e| e.slug == 'E0' }.first
  end

  context 'during initialization' do
    it 'has seeded models set' do
      expect(CodeWars::DataStore::SEEDED_MODELS).to eq(%w[Event Decision])
    end
    describe '#define_models_getters' do
      it 'defines seed models getters methods' do
        CodeWars::DataStore::SEEDED_MODELS.each do |seed_model|
          expect(CodeWars::DataStore.instance).to respond_to(seed_model.underscore.pluralize.to_sym)
        end
      end
      it 'seed models getters returns seed data' do
        CodeWars::DataStore::SEEDED_MODELS.each do |seed_model|
          seed_model_name = seed_model.underscore.pluralize.to_sym
          expect(CodeWars::DataStore.instance.send(seed_model_name).count)
            .to be > 0
        end
      end
    end
  end

  describe '#seed' do
    context 'as it seeds data in from yml files' do
      it 'contains all imported data in memory' do
        expect(CodeWars::DataStore.instance.data.count).to be > 0
        # TODO : update this spec to check the exact finaly number of events
        expect(CodeWars::DataStore.instance.data[:events].count).to be > 0
      end
    end
  end
end
