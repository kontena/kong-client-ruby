module Kong
  module BelongsToService
    attr_accessor :service

    # Convert Service end point relative to Kong API resource
    def use_service_end_point
      self.api_end_point = "/services/#{self.service_id}#{self.class::API_END_POINT}" if self.service_id
    end

    # Get Service resource
    # @return [Kong::Service]
    def service
      @service ||= Service.find(self.service_id)
    end

    # Set Service resource
    # @param [Kong::Service] service
    def service=(service)
      @service = service
      self.service_id = service.id
    end

    # Set Service id
    # @param [String] id
    def service_id=(id)
      super(id)
      use_service_end_point
    end
  end
end
