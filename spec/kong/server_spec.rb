require_relative "../spec_helper"

describe Kong::Server do
  describe '.info' do
    it 'makes GET / request' do
      expect(Kong::Client.instance).to receive(:get).with('/')
      described_class.info
    end
  end

  describe '.version' do
    it 'returns version information' do
      allow(Kong::Client.instance).to receive(:get).with('/')
        .and_return({ 'version' => '0.10.0' })
      expect(described_class.version).to eq('0.10.0')
    end
  end

  describe '.status' do
    it 'makes GET /status request' do
      expect(Kong::Client.instance).to receive(:get).with('/status')
      described_class.status
    end
  end

  describe '.cluster' do
    it 'makes GET /cluster request' do
      expect(Kong::Client.instance).to receive(:get).with('/cluster')
      described_class.cluster
    end
  end

  describe '.remove_node' do
    it 'makes DELETE /cluster/nodes/:name request' do
      expect(Kong::Client.instance).to receive(:delete).with('/cluster/nodes/:name')
      described_class.remove_node(':name')
    end
  end
end
