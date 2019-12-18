require_relative "../spec_helper"

describe Kong::Route do
  let(:valid_attribute_names) do
    %w(
      id name protocols methods hosts paths
      regex_priority strip_path preserve_host
      service_id tags
    )
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/routes/')
    end
  end

  describe '.plugins' do
    it 'requests plugins attached to Route' do
      subject.id = '12345'
      expect(Kong::Plugin).to receive(:list).with({ route_id: subject.id })
      subject.plugins
    end
  end
end
