module Kong
  class Route
    include Base

    ATTRIBUTE_NAMES = %w(
      id name protocols methods hosts paths
      regex_priority strip_path preserve_host
      service_id tags
    ).freeze
    API_END_POINT = '/routes/'.freeze

    ##
    # @return [Array<Kong::Plugin>]
    def plugins
      Plugin.list({ route_id: self.id })
    end
  end
end
