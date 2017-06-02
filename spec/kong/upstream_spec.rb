require_relative "../spec_helper"

describe Kong::Upstream do
  let(:valid_attribute_names) do
    %w(id name slots orderlist)
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains a valid end point' do
      expect(subject.class::API_END_POINT).to eq('/upstreams/')
    end
  end

  describe '.targets' do
    it 'requests targets attached to the Upstream' do
      subject.id = '12345'

      expect(Kong::Client.instance)
        .to receive(:get).with("/upstreams/12345/targets")
        .and_return({
          'data'  => [{ 'upstream_id' => 12345, 'target' => 'google.com:80', 'weight' => 100 }],
          'total' => 1
        })

      targets = subject.targets

      expect(targets.size).to eq(1)
      expect(targets.first).to be_a(Kong::Target)
    end
  end
end
