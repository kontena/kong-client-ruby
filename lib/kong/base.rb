module Kong
  module Base
    module ClassMethods

      # List resources
      # @return [Array]
      def list(params = {})
        result = []
        json_data = Client.instance.get(self::API_END_POINT, params)
        if json_data['data']
          json_data['data'].each do |instance|
            result << self.new(instance)
          end
        end
        result
      end

      alias_method :all, :list

      # Create resource
      # @param [Hash] attributes
      def create(attributes = {})
        self.new(attributes).create
      end

      # Find resource
      # @param [String] id
      def find(id)
        self.new.get(id)
      end

      def method_missing(method, *arguments, &block)
        if method.to_s.start_with?('find_by_')
          attribute = method.to_s.sub('find_by_', '')
          if self.attribute_names.include?(attribute)
            self.list({ attribute => arguments[0] })[0]
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
    def initialize(attributes = {})
      init_api_end_point
      init_attributes(attributes)
    end

    # Get Kong API client
    # @return [Kong::Client]
    def client
      Client.instance
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

    # Save resource to Kong
    def save
      create_or_update
    end

    # Create resource
    def create
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
      attributes.each do |key, value|
        @attributes[key.to_s] = value
      end
      use_consumer_end_point if respond_to?(:use_consumer_end_point)
      use_api_end_point if respond_to?(:use_api_end_point)
      use_upstream_end_point if respond_to?(:use_upstream_end_point)
    end
  end
end
