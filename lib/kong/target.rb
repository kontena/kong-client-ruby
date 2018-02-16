module Kong
  class Target
    include Base
    include Rootless

    ATTRIBUTE_NAMES = %w(id upstream_id target weight).freeze
    API_END_POINT = '/targets/'.freeze


    def initialize(attributes = {}, opts = {})
      super(attributes, opts)
      raise ArgumentError, 'You must specify an upstream_id' unless self.upstream_id
    end

    def active?
      self.weight > 0
    end

    def save
      create
    end

    def create_or_update
      raise NotImplementedError, 'Kong does not support updating targets, you must delete and re-create'
    end

    def update
      raise NotImplementedError, 'Kong does not support updating targets, you must delete and re-create'
    end

    def use_upstream_end_point
      self.api_end_point = "/upstreams/#{self.upstream_id}#{self.class::API_END_POINT}" if self.upstream_id
    end

    # Get Upstream resource
    # @return [Kong::Upstream]
    def upstream
      @upstream ||= Upstream.find(self.upstream_id, client: self.client)
    end

    # Set Upstream resource
    # @param [Kong::Upstream] upstream
    def upstream=(upstream)
      @upstream = upstream
      self.upstream_id = upstream.id
    end

    # Set Upstream id
    # @param [String] id
    def upstream_id=(id)
      super(id)
      use_upstream_end_point
    end
  end
end
