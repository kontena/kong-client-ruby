require_relative "../spec_helper"

describe Kong::HmacAuth do
  let(:valid_attribute_names) do
    %w(id username consumer_id)
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/hmac-auth/')
    end
  end

  describe '#init_attributes' do
    it 'uses correct api end point if api_id is present' do
      subject = described_class.new({ consumer_id: ':consumer_id' })
      expect(subject.api_end_point).to eq('/consumers/:consumer_id/hmac-auth/')
    end
  end
end
