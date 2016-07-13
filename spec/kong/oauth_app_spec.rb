require_relative "../spec_helper"

describe Kong::OAuthApp do
  let(:valid_attribute_names) do
    %w(id name client_id client_secret redirect_uri consumer_id)
  end

  describe '::ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe '::API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/oauth2/')
    end
  end
end
