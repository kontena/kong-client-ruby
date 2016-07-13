require_relative "../spec_helper"

describe Kong::OAuth2Token do
  let(:valid_attribute_names) do
    %w(id credential_id expires_in created_at token_type access_token refresh_token scope authenticated_userid)
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/oauth2_tokens/')
    end
  end
end
