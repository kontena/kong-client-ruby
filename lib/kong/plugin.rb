require_relative './util'

module Kong
  class Plugin
    include Base
    include BelongsToApi

    ATTRIBUTE_NAMES = %w(id api_id name config enabled consumer_id).freeze
    API_END_POINT = '/plugins/'.freeze

    # Create resource
    def create
      flatten_config
      super
    end

    # Create or update resource
    def create_or_update
      flatten_config
      super
    end

    # Update resource
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
