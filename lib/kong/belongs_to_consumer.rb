module Kong
  module BelongsToConsumer
    attr_accessor :consumer

    # Convert API end point relative to Kong Consumer resource
    def use_consumer_end_point
      self.api_end_point = "/consumers/#{self.consumer_id}#{self.class::API_END_POINT}" if self.consumer_id
    end

    # Get Consumer resource
    # @return [Kong::Consumer]
    def consumer
      @consumer ||= Consumer.find(self.consumer_id, client: self.client)
    end

    # Set Consumer resource
    # @param [Kong::Consumer] consumer
    def consumer=(consumer)
      @consumer = consumer
      self.consumer_id = consumer.id
    end

    # Set Consumer id
    # @param [String] id
    def consumer_id=(id)
      super(id)
      use_consumer_end_point
    end
  end
end
