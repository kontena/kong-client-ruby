require_relative "../spec_helper"

describe Kong::Error do
  let(:instance) { described_class.new(status, message) }
  let(:status) { 123 }
  let(:message) { 'Error Message' }

  describe '.status' do
    subject { instance.status }

    it 'exposes error status' do
      is_expected.to eq status
    end
  end

  describe '.message' do
    subject { instance.message }

    it 'exposes error message' do
      is_expected.to eq message
    end
  end
end
