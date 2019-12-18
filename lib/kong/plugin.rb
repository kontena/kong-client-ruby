require_relative './util'

module Kong
  class Plugin
    include Base
    include BelongsToService

    ATTRIBUTE_NAMES = %w(
      id name config enabled route_id service_id consumer_id protocols
      tags
    ).freeze
    API_END_POINT = '/plugins/'.freeze

    # Create resource
    def create
      flatten_config
      super
    end

    # update resource
    def update
      flatten_config
      super
    end

    private

    def flatten_config
      if attributes['config']
        attributes.merge!(Util.flatten(attributes.delete('config'), 'config'))
      end
    end
  end
end
