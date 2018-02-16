module Kong
  class Api
    include Base

    ATTRIBUTE_NAMES = %w(
      id name request_host request_path strip_request_path
      hosts uris strip_uri preserve_host upstream_url retries
      upstream_connect_timeout upstream_send_timeout upstream_read_timeout
      https_only http_if_terminated methods
    ).freeze
    API_END_POINT = '/apis/'.freeze

    ##
    # @return [Array<Kong::Plugin>]
    def plugins
      Plugin.list({ api_id: self.id }, client: self.client)
    end
  end
end
