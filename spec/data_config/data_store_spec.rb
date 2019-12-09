RSpec.describe 'DataStore' do           #
  context 'before configuration' do  # (almost) plain English
    it 'has seeded models set' do   #
      expect(CodeWars::DataStore::SEEDED_MODELS).to eq(%w(Event Decision))  # test code
    end
  end

  context 'as it seeds data in from yml files' do
    it 'contains all imported data in memory' do
      CodeWars::DataStore.instance.seed
      expect(CodeWars::DataStore.instance.data.count).to be > 0
      expect(CodeWars::DataStore.instance.data[:events].count).to be > 0
    end
  end
end
