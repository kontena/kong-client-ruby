module Kong
  class Target
    include Base

    ATTRIBUTE_NAMES = %w(id upstream_id target weight).freeze
    API_END_POINT = '/targets/'.freeze

    def self.find(id)
      raise NotImplementedError, 'Kong does not support direct access to targets, you must go via an upstream'
    end

    def self.list(params = {})
      raise NotImplementedError, 'Kong does not support direct access to targets, you must go via an upstream'
    end

    def initialize(attributes = {})
      super(attributes)
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
      @upstream ||= Upstream.find(self.upstream_id)
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
