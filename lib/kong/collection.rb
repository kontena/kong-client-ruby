module Kong
  class Collection
    def initialize(klass, client, api_end_point = nil)
      @klass = klass
      @client = client
      @api_end_point = api_end_point
    end

    def first
      self.list.first
    end

    def last
      self.all.last
    end

    def method_missing(method, *arguments, &block)
      opts = { client: @client, collection: self, api_end_point: @api_end_point }
      if arguments.size == 0
        arguments = [{}, opts]
      else
        arguments << opts
      end
      @klass.send(method, *arguments)
    end

    def respond_to?(method, include_private = false)
      @klass.respond_to?(method, include_private)
    end
  end
end