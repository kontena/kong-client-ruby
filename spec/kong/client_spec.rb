require_relative "../spec_helper"

describe Kong::Client do

  let(:subject) do
    described_class.instance
  end

  let(:http_client) do
    spy
  end

  describe '.api_url=' do
    it 'updates api_url attribute' do
      described_class.api_url = 'http://kong-api:8001'
      expect(described_class.api_url).to eq('http://kong-api:8001')
    end

    it 'updates client instance' do
      described_class.api_url = 'http://kong-api:8001'
      expect(described_class.instance.api_url).to eq('http://kong-api:8001')
    end
  end

  describe '.instance' do
    it 'returns shared instance' do
      expect(described_class.instance.is_a?(described_class)).to be_truthy
    end
  end

  describe '#initialize' do
    it 'initializes Excon with Kong URI' do
      described_class.api_url = nil
      expect(Excon).to receive(:new).with('http://localhost:8001', { omit_default_port: true })
      described_class.send(:new)
    end

    it 'initializes default headers' do
      expect(described_class.instance.default_headers).to eq({ 'Accept' => 'application/json' })
      described_class.send(:new)
    end
  end

  describe '#api_url' do

    def client_params
      uri = URI.parse described_class.api_url
      params = {
        host: uri.host,
        hostname: uri.hostname,
        path: uri.path,
        port: uri.port,
        query: uri.query,
        scheme: uri.scheme
      }
      described_class.instance.http_client.params.merge(params)
    end

    it 'returns localhost as default' do
      described_class.api_url = nil
      expect(subject.api_url).to eq('http://localhost:8001')
    end

    it 'returns value from environment variable' do
      allow(ENV).to receive(:[]).with('NO_PROXY')
      allow(ENV).to receive(:[]).with('no_proxy')
      allow(ENV).to receive(:[]).with('SSL_IGNORE_ERRORS')
      allow(ENV).to receive(:[]).with('KONG_URI').and_return('http://kong-api:8001')
      described_class.api_url = nil
      subject = described_class.send(:new)
      expect(subject.api_url).to eq('http://kong-api:8001')
    end

    it 'returns custom api_url if set' do
      url = 'http://foo.bar:1337'
      described_class.api_url = url
      expect(described_class.send(:new).api_url).to eq(url)
    end

    it 'can edit api_url' do
      described_class.api_url = nil
      expect(described_class.instance.http_client.params).to eq(client_params)
      described_class.api_url = 'http://foo.bar:1337'
      expect(described_class.instance.http_client.params).to eq(client_params)
    end
  end

  describe '#consumers' do
    it 'returns Collection object for Kong::Consumer' do
      expect(Kong::Collection).to receive(:new).with(Kong::Consumer, subject).and_call_original
      subject.consumers
    end
  end

  describe '#apis' do
    it 'returns Collection object for Kong::Api' do
      expect(Kong::Collection).to receive(:new).with(Kong::Api, subject).and_call_original
      subject.apis
    end
  end

  describe '#oauth_apps' do
    it 'returns Collection object for Kong::OAuthApp' do
      expect(Kong::Collection).to receive(:new).with(Kong::OAuthApp, subject).and_call_original
      subject.oauth_apps
    end
  end

  describe '#oauth2_tokens' do
    it 'returns Collection object for Kong::OAuth2Token' do
      expect(Kong::Collection).to receive(:new).with(Kong::OAuth2Token, subject).and_call_original
      subject.oauth2_tokens
    end
  end

  describe '#plugins' do
    it 'returns Collection object for Kong::Plugin' do
      expect(Kong::Collection).to receive(:new).with(Kong::Plugin, subject).and_call_original
      subject.plugins
    end
  end

  describe '#targets' do
    it 'returns Collection object for Kong::Target' do
      expect(Kong::Collection).to receive(:new).with(Kong::Target, subject).and_call_original
      subject.targets
    end
  end

  describe '#info' do
    it 'request root endpoint' do
      expect(subject).to receive(:get).with('/')
      subject.info
    end
  end

  describe '#status' do
    it 'request status endpoint' do
      expect(subject).to receive(:get).with('/status')
      subject.status
    end
  end

  describe '#cluster' do
    it 'request cluster endpoint' do
      expect(subject).to receive(:get).with('/cluster')
      subject.cluster
    end
  end

  describe '#get' do
    before(:each) do
      allow(subject).to receive(:http_client).and_return(http_client)
    end
    it 'creates HTTP GET request with given params' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      expect(http_client).to receive(:get).and_return(response)
      subject.get('path', { key: 'value' })
    end

    it 'raises Kong::Error if request returns error' do
      response = spy
      allow(response).to receive(:status).and_return(403)
      expect(http_client).to receive(:get).and_return(response)
      expect {
        subject.get('path', { key: 'value' })
      }.to raise_error(Kong::Error)
    end

    it 'parses response JSON' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return({ id: '12345' }.to_json)
      allow(response).to receive(:headers).and_return({ 'Content-Type' => 'application/json' })
      allow(http_client).to receive(:get).and_return(response)
      expect(subject.get('path', { key: 'value' })).to eq({ 'id' => '12345' })
    end

    it 'returns response text' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return('<html></html>')
      allow(response).to receive(:headers).and_return({ 'Content-Type' => 'text/html' })
      allow(http_client).to receive(:get).and_return(response)
      expect(subject.get('path', { key: 'value' })).to eq('<html></html>')
    end
  end

  describe '#post' do
    before(:each) do
      allow(subject).to receive(:http_client).and_return(http_client)
    end
    it 'creates HTTP POST request with given params' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      expect(http_client).to receive(:post).and_return(response)
      subject.post('path', nil, { key: 'value' })
    end


    it 'raises Kong::Error if request returns error' do
      response = spy
      allow(response).to receive(:status).and_return(403)
      expect(http_client).to receive(:post).and_return(response)
      expect {
        subject.post('path', nil, { key: 'value' })
      }.to raise_error(Kong::Error)
    end

    it 'parses response JSON' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return({ id: '12345' }.to_json)
      allow(response).to receive(:headers).and_return({ 'Content-Type' => 'application/json' })
      allow(http_client).to receive(:post).and_return(response)
      expect(subject.post('path', nil, { key: 'value' })).to eq({ 'id' => '12345' })
    end
  end
  describe '#patch' do
    before(:each) do
      allow(subject).to receive(:http_client).and_return(http_client)
    end
    it 'creates HTTP PATCH request with given params' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      expect(http_client).to receive(:patch).and_return(response)
      subject.patch('path', nil, { key: 'value' })
    end


    it 'raises Kong::Error if request returns error' do
      response = spy
      allow(response).to receive(:status).and_return(403)
      expect(http_client).to receive(:patch).and_return(response)
      expect {
        subject.patch('path', nil, { key: 'value' })
      }.to raise_error(Kong::Error)
    end

    it 'parses response JSON' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return({ id: '12345' }.to_json)
      allow(response).to receive(:headers).and_return({ 'Content-Type' => 'application/json' })
      allow(http_client).to receive(:patch).and_return(response)
      expect(subject.patch('path', nil, { key: 'value' })).to eq({ 'id' => '12345' })
    end
  end

  describe '#put' do
    before(:each) do
      allow(subject).to receive(:http_client).and_return(http_client)
    end
    it 'creates HTTP PUT request with given params' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      expect(http_client).to receive(:put).and_return(response)
      subject.put('path', nil, { key: 'value' })
    end


    it 'raises Kong::Error if request returns error' do
      response = spy
      allow(response).to receive(:status).and_return(403)
      expect(http_client).to receive(:put).and_return(response)
      expect {
        subject.put('path', nil, { key: 'value' })
      }.to raise_error(Kong::Error)
    end

    it 'parses response JSON' do
      response = spy
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return({ id: '12345' }.to_json)
      allow(response).to receive(:headers).and_return({ 'Content-Type' => 'application/json' })
      allow(http_client).to receive(:put).and_return(response)
      expect(subject.put('path', nil, { key: 'value' })).to eq({ 'id' => '12345' })
    end
  end

  describe '#delete' do
    before(:each) do
      allow(subject).to receive(:http_client).and_return(http_client)
    end
    it 'creates HTTP DELETE request with given params' do
      response = spy
      allow(response).to receive(:status).and_return(204)
      expect(http_client).to receive(:delete).and_return(response)
      subject.delete('path', nil, {})
    end


    it 'raises Kong::Error if request returns other than 204' do
      response = spy
      allow(response).to receive(:status).and_return(403)
      expect(http_client).to receive(:delete).and_return(response)
      expect {
        subject.delete('path', nil, {})
      }.to raise_error(Kong::Error)
    end
  end
end
