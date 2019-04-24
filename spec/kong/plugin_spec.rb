require_relative "../spec_helper"

describe Kong::Plugin do
  let(:valid_attribute_names) do
    %w(id name config enabled route_id service_id consumer_id protocols tags)
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/plugins/')
    end
  end

  describe '#init_attributes' do
    it 'uses correct service end point if service_id is present' do
      subject = described_class.new({ service_id: ':service_id' })
      expect(subject.api_end_point).to eq('/services/:service_id/plugins/')
    end
  end

  describe '#create' do
    it 'transforms config keys to config.key format' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'service_id' => ':service_id', 'config.anonymous' => '12345' }
      expect(Kong::Client.instance).to receive(:post).with('/services/:service_id/plugins/', attributes, nil, headers).and_return(attributes)
      subject = described_class.new({ service_id: ':service_id', config: { 'anonymous' => '12345' } })
      subject.create
    end

    it 'transforms nested config keys to config.key format' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'service_id' => ':service_id', 'config.anonymous' => '12345', 'config.first.second' => '1' }
      expect(Kong::Client.instance).to receive(:post).with('/services/:service_id/plugins/', attributes, nil, headers).and_return(attributes)
      subject = described_class.new({ service_id: ':service_id', config: { 'anonymous' => '12345', 'first' => { 'second' => '1' } } })
      subject.create
    end
  end

  describe '#update' do
    it 'transforms config keys to config.key format' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'service_id' => ':service_id', 'config.anonymous' => '12345' }
      expect(Kong::Client.instance).to receive(:patch).with('/services/:service_id/plugins/', attributes, nil, headers).and_return(attributes)
      subject = described_class.new({ service_id: ':service_id', config: { 'anonymous' => '12345' } })
      subject.update
    end

    it 'transforms nested config keys to config.key format' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'service_id' => ':service_id', 'config.anonymous' => '12345', 'config.first.second' => '1' }
      expect(Kong::Client.instance).to receive(:patch).with('/services/:service_id/plugins/', attributes, nil, headers).and_return(attributes)
      subject = described_class.new({ service_id: ':service_id', config: { 'anonymous' => '12345', 'first' => { 'second' => '1' } } })
      subject.update
    end
  end
end
