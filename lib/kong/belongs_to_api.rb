module Kong
  module BelongsToApi
    attr_accessor :api

    # Convert API end point relative to Kong API resource
    def use_api_end_point
      self.api_end_point = "/apis/#{self.api_id}#{self.class::API_END_POINT}" if self.api_id
    end

    # Get Api resource
    # @return [Kong::Api]
    def api
      @api ||= Api.find(self.api_id, client: self.client)
    end

    # Set Api resource
    # @param [Kong::Api] api
    def api=(api)
      @api = api
      self.api_id = api.id
    end

    # Set Api id
    # @param [String] id
    def api_id=(id)
      super(id)
      use_api_end_point
    end
  end
end
