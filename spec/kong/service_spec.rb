require_relative "../spec_helper"

describe Kong::Service do
  let(:valid_attribute_names) do
    %w(
      id name retries protocol host port path
      connect_timeout write_timeout upstream_read_timeout
      tags
    )
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/services/')
    end
  end

  describe '.plugins' do
    it 'requests plugins attached to Service' do
      subject.id = '12345'
      expect(Kong::Plugin).to receive(:list).with({ service_id: subject.id })
      subject.plugins
    end
  end
end
