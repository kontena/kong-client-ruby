module Kong
  module BelongsToConsumer
    attr_accessor :consumer

    # Convert API end point relative to Kong Consumer resource
    def use_consumer_end_point
      self.api_end_point = "/consumers/#{self.consumer.id}#{self.class::API_END_POINT}" if self.consumer && self.consumer.id
    end

    # Get Consumer resource
    # @return [Kong::Consumer]
    def consumer
      if @consumer
        return @consumer
      elsif self.attributes['consumer'] && self.attributes['consumer'].instance_of?(Hash)
        return @consumer = Consumer.new(attributes['consumer'])
      elsif self.attributes['consumer'] && self.attributes['consumer'].instance_of?(Kong::Consumer)
        @consumer = self.attributes['consumer']
        return @consumer
      end
      # @consumer ||= Consumer.find(self.consumer.id)
      # @consumer ||= self.consumer
    end

    # def initialize(attributes = {})
    #   super(attributes)
    #   use_consumer_end_point
    # end

    # Set Consumer resource
    # @param [Kong::Consumer] consumer
    def consumer=(consumer)
      @consumer = consumer
      # self.consumer_attrs = { id: consumer.id }
      # super(consumer)
      # self.consumer = consumer
      use_consumer_end_point
    end

    # # Set Consumer id
    # # @param [String] id
    # def consumer_id=(id)
    #   super(id)
    # end

    # Set Consumer attributes
    # @param [Hash] attributes
    # def consumer_attr=(attrs)
    #   super(attrs)
    #   use_consumer_end_point
    # end
  end
end
