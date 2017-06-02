require_relative "../spec_helper"

describe Kong::Target do
  let(:upstream_id) { '1234' }

  let(:valid_attribute_names) do
    %w(id upstream_id target weight)
  end

  subject { described_class.new(upstream_id: upstream_id) }

  context 'without an upstream_id' do
    it 'raises an ArgumentError' do
      expect { described_class.new }
        .to raise_error(ArgumentError)
    end
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/targets/')
    end
  end

  describe '#init_attributes' do
    it 'uses the correct api end point if the upstream_id is present' do
      expect(subject.api_end_point).to eq("/upstreams/#{upstream_id}/targets/")
    end
  end

  describe '.upstream' do
    it 'requests the attached Upstream' do
      expect(Kong::Upstream).to receive(:find).with(upstream_id)
      subject.upstream
    end
  end

  describe '.active?' do
    it 'returns true if the weight is > 0' do
      target1 = described_class.new(upstream_id: upstream_id, target: 'google.com', weight: 100)
      target2 = described_class.new(upstream_id: upstream_id, target: 'google.com', weight: 0)

      expect(target1).to be_active
      expect(target2).to_not be_active
    end
  end
end
