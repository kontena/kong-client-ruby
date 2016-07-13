module Kong
  class Api
    include Base

    ATTRIBUTE_NAMES = %w(id name request_host request_path strip_request_path preserve_host upstream_url).freeze
    API_END_POINT = '/apis/'.freeze

    ##
    # @return [Array<Kong::Plugin>]
    def plugins
      Plugin.list({ api_id: self.id })
    end
  end
end
