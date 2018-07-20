require_relative "../spec_helper"

describe Kong::Base do

  let(:resource_class) do
    Class.new do
      include Kong::Base

    end
  end

  let(:subject) do
    Klass.new
  end

  before do
    stub_const 'Klass', resource_class
    stub_const 'Klass::API_END_POINT', '/resources/'
    stub_const 'Klass::ATTRIBUTE_NAMES', %w(id name)
  end

  describe '.list' do
    it 'requests GET /:resource_end_point/' do
      expect(Kong::Client.instance).to receive(:get).with('/resources/', {}).and_return({ data: [] })
      Klass.list
    end

    it 'returns array of resource instances' do
      allow(Kong::Client.instance).to receive(:get).with('/resources/', {})
        .and_return({ 'data' => [{ 'id' => '12345', 'name' => 'resource' }] })
      result = Klass.list
      expect(result[0].is_a?(Klass)).to be_truthy
    end
  end

  describe '.all' do
    it 'is alias of .list' do
      expect(Klass.method(:list)).to eq(Klass.method(:all))
    end
  end

  describe '.find' do
    it 'creates GET /:resource_end_point/:id request' do
      expect(Kong::Client.instance).to receive(:get).with('/resources/12345').and_return({ data: [] })
      Klass.find('12345')
    end
  end

  describe '.respond_to' do
    context 'when attribute exits' do
      it 'will respond to find_by_* methods' do
        expect(Klass.respond_to?(:find_by_name)).to be_truthy
      end
    end

    context 'when attribute does not exit' do
      it 'will not respond to find_by_* methods' do
        expect(Klass.respond_to?(:find_by_invalid)).to be_falsey
      end
    end
  end

  describe '#get' do
    it 'creates GET /:resource_end_point/:id request' do
      expect(Kong::Client.instance).to receive(:get).with('/resources/12345').and_return({ data: [] })
      subject.get('12345')
    end

    it 'returns resource instance' do
      allow(Kong::Client.instance).to receive(:get).with('/resources/12345')
        .and_return({ 'data' => [{ 'id' => '12345', 'name' => 'resource' }] })
      result = subject.get('12345')
      expect(result.is_a?(Klass)).to be_truthy
    end

    it 'returns nil if resource is not found' do
      allow(Kong::Client.instance).to receive(:get).with('/resources/123456')
        .and_return(nil)
      result = subject.get('123456')
      expect(result).to be_nil
    end
  end

  describe '#new?' do
    it 'returns true if resource id is missing' do
      expect(subject.new?).to be_truthy
    end

    it 'returns false if resource has id' do
      subject.id = '12345'
      expect(subject.new?).to be_falsey
    end
  end

  describe '#create' do
    it 'creates POST /:resource_end_point/ request with resource attributes' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'name' => 'test object' }
      expect(Kong::Client.instance).to receive(:post).with('/resources/', attributes, nil, headers)
        .and_return(attributes)
      subject.name = 'test object'
      subject.create
    end

    it 'returns resource instance' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'name' => 'test object' }
      allow(Kong::Client.instance).to receive(:post).with('/resources/', attributes, nil, headers)
        .and_return(attributes.merge({ 'id' => '12345' }))
      subject.name = 'test object'
      expect(subject.create).to eq(subject)
      expect(subject.id).to eq('12345')
    end
  end

  describe '#create_or_update' do
    it 'creates PUT /:resource_end_point/ request with resource attributes as json payload' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'name' => 'test object' }
      expect(Kong::Client.instance).to receive(:put).with('/resources/', attributes, nil, headers)
        .and_return(attributes.merge({ 'id' => '12345' }))
      subject.name = 'test object'
      subject.create_or_update
    end

    it 'returns resource instance' do
      headers = { 'Content-Type' => 'application/json' }
      attributes = { 'name' => 'test object' }
      expect(Kong::Client.instance).to receive(:put).with('/resources/', attributes, nil, headers)
        .and_return(attributes.merge({ 'id' => '12345' }))
      subject.name = 'test object'
      expect(subject.create_or_update).to eq(subject)
    end

    describe '#update' do
      it 'creates PATCH /:resource_end_point/:resource_id request with resource attributes' do
        headers = { 'Content-Type' => 'application/json' }
        subject.id = '12345'
        subject.name = 'test object'
        expect(Kong::Client.instance).to receive(:patch).with('/resources/12345', subject.attributes, nil, headers)
          .and_return(subject.attributes)
        subject.update
      end

      it 'returns resource instance' do
        headers = { 'Content-Type' => 'application/json' }
        subject.id = '12345'
        subject.name = 'test object'
        allow(Kong::Client.instance).to receive(:patch).with('/resources/12345', subject.attributes, nil, headers)
          .and_return(subject.attributes)
        expect(subject.update).to eq(subject)
      end
    end

    it 'will respond to attribute' do
      expect(subject.respond_to?(:name)).to be_truthy
    end

  end

end
