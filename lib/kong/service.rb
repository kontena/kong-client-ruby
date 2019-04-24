module Kong
  class Service
    include Base

    ATTRIBUTE_NAMES = %w(
      id name retries protocol host port path
      connect_timeout write_timeout upstream_read_timeout
      tags
    ).freeze
    API_END_POINT = '/services/'.freeze

    ##
    # @return [Array<Kong::Plugin>]
    def plugins
      Plugin.list({ service_id: self.id })
    end
  end
end
