require_relative "../spec_helper"

describe Kong::Consumer do
  let(:valid_attribute_names) do
    %w(id custom_id username created_at)
  end

  describe '::ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe '::API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/consumers/')
    end
  end

  describe '#oauth_apps' do
    it 'requests consumer\'s oauth_apps' do
      subject.id = ':id'
      expect(Kong::Client.instance).to receive(:get).with("/consumers/:id/oauth2")
        .and_return({ 'data' => [{ 'id' => '123456', 'name' => 'my app' }] })
      subject.oauth_apps
    end

    it 'returns list of OAuthApp' do
      subject.id = ':id'
      allow(Kong::Client.instance).to receive(:get).with("/consumers/:id/oauth2")
        .and_return({ 'data' => [{ 'id' => '123456', 'name' => 'my app' }] })
      result = subject.oauth_apps
      expect(result.first.is_a?(Kong::OAuthApp)).to be_truthy
    end
  end

  describe '#oauth2_tokens' do
    context 'when custom_id is set' do
      it 'requests oauth2_tokens assigned to consumer' do
        subject.custom_id = 'custom_id'
        expect(Kong::OAuth2Token).to receive(:list).with({ authenticated_userid: subject.custom_id })
        subject.oauth2_tokens
      end
    end
    context 'when custom_id is not set' do
      it 'requests oauth2_tokens assigned to consumer' do
        expect(Kong::OAuth2Token).not_to receive(:list)
        subject.oauth2_tokens
      end
      it 'returns empty array' do
        expect(subject.oauth2_tokens).to eq([])
      end
    end
  end

  describe '#acls' do
    it 'requests consumer\'s acls' do
      subject.id = ':id'
      expect(Kong::Client.instance).to receive(:get).with("/consumers/:id/acls")
        .and_return({ 'data' => [{ 'id' => '123456', 'group' => 'group1' }] })
      subject.acls
    end

    it 'returns list of Acls' do
      subject.id = ':id'
      allow(Kong::Client.instance).to receive(:get).with("/consumers/:id/acls")
        .and_return({ 'data' => [{ 'id' => '123456', 'group' => 'group1' }] })
      result = subject.acls
      expect(result.first.is_a?(Kong::Acl)).to be_truthy
    end
  end
end
