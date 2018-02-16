module Kong
  module Base
    module ClassMethods

      # List resources
      # @return [Array]
      def list(params = {}, opts = {})
        opts = {} if opts.nil?
        client = opts[:client] ? opts[:client] : Client.instance
        collection = opts[:collection] ? opts[:collection] : Collection.new(self, client)
        api_end_point = opts[:api_end_point] ? opts[:api_end_point] : self::API_END_POINT
        result = []
        json_data = client.get(api_end_point, params)
        if json_data['data']
          json_data['data'].each do |instance|
            result << self.new(instance, { client: client, collection: collection })
          end
        end
        result
      end

      def all(params = {}, opts = {})
        self.list({ size: 9999999 }, opts)
      end

      def first(opts={})
        self.list({},opts).first
      end

      # Create resource
      # @param [Hash] attributes
      def create(attributes = {}, opts = {})
        self.new(attributes, opts).create
      end

      # Find resource
      # @param [String] id
      def find(id, opts = {})
        self.new({}, opts).get(id)
      end

      def method_missing(method, *arguments, &block)
        if method.to_s.start_with?('find_by_')
          attribute = method.to_s.sub('find_by_', '')
          if self.attribute_names.include?(attribute)
            self.list({ attribute => arguments[0] }, arguments[1])[0]
          else
            super
          end
        else
          super
        end
      end

      def respond_to?(method, include_private = false)
        if method.to_s.start_with?('find_by_')
          attribute = method.to_s.sub('find_by_', '')
          if self.attribute_names.include?(attribute)
            return true
          else
            super
          end
        else
          super
        end
      end
    end

    attr_accessor :attributes, :api_end_point
    attr_reader :client, :collection

    def self.included(base)
      base.extend(ClassMethods)

      base.send(:define_singleton_method, :attribute_names) do
        base::ATTRIBUTE_NAMES
      end

      base.send(:define_method, :init_api_end_point) do
        @api_end_point = base::API_END_POINT
      end
    end

    ##
    # @param [Hash] attributes
    def initialize(attributes = {}, opts = {})
      @client = opts[:client] ? opts[:client] : Client.instance
      @collection = opts[:collection] ? opts[:collection] : Collection.new(self.class, @client)
      init_api_end_point
      init_attributes(attributes)
    end

    # Get resource
    # @param [String] key
    def get(key = nil)
      key = self.id if key.nil?
      path = @api_end_point + key
      response = client.get(path) rescue nil
      return nil if response.nil?
      init_attributes(response)
      self
    end

    # Delete resource
    def delete
      client.delete("#{@api_end_point}#{self.id}")
    end

    def new?
      self.id.nil?
    end

    def set(attributes)
      self.attributes = attributes
      self.attributes
    end

    def to_s
      self.attributes.to_s
    end

    def to_json
      self.attributes.to_json
    end

    def inspect
      self.attributes.inspect
    end
    # Save resource to Kong
    def save
      create_or_update
    end

    # Create resource
    def create(attributes = {})
      attributes = self.attributes.merge(attributes)
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      response = client.post(@api_end_point, nil, attributes, headers)
      init_attributes(response)
      self
    end

    # Create or update resource
    # Data is sent to Kong in JSON format and HTTP PUT request is used
    def create_or_update
      headers = { 'Content-Type' => 'application/json' }
      response = client.put("#{@api_end_point}", attributes, nil, headers)
      init_attributes(response)
      self
    end

    # Update resource
    def update
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
      response = client.patch("#{@api_end_point}#{self.id}", nil, attributes, headers)
      init_attributes(response)
      self
    end

    def method_missing(method, *arguments, &block)
      if self.class.attribute_names.include?(method.to_s)
        @attributes[method.to_s]
      elsif method.to_s.end_with?('=') && self.class.attribute_names.include?(attribute = method.to_s.split('=').first)
        @attributes[attribute] = arguments[0]
      else
        super
      end
    end

    def respond_to?(method, include_private = false)
      if self.class.attribute_names.include?(method.to_s.split('=')[0])
        true
      else
        super
      end
    end

    private

    def init_attributes(attributes)
      @attributes = {}
      self.attributes = attributes
    end

    def attributes=(attributes)
      attributes.each do |key, value|
        @attributes[key.to_s] = value if self.class.attribute_names.include?(key.to_s)
      end
      use_consumer_end_point if respond_to?(:use_consumer_end_point)
      use_api_end_point if respond_to?(:use_api_end_point)
      use_upstream_end_point if respond_to?(:use_upstream_end_point)
    end
  end
end
