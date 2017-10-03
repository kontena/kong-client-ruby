require_relative "../spec_helper"

describe Kong::Api do
  let(:valid_attribute_names) do
    %w(
      id name request_host request_path strip_request_path
      hosts uris strip_uri preserve_host upstream_url retries
      upstream_connect_timeout upstream_send_timeout upstream_read_timeout
      https_only http_if_terminated methods
    )
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/apis/')
    end
  end

  describe '.plugins' do
    it 'requests plugins attached to Api' do
      subject.id = '12345'
      expect(Kong::Plugin).to receive(:list).with({ api_id: subject.id })
      subject.plugins
    end
  end
end
