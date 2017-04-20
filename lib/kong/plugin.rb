module Kong
  class Plugin
    include Base
    include BelongsToApi

    ATTRIBUTE_NAMES = %w(id api_id name config enabled consumer_id).freeze
    API_END_POINT = '/plugins/'.freeze

    # Create resource
    def create
      if attributes['config']
        attributes['config'].each do |key, value|
          attributes["config.#{key}"] = value
        end
        attributes.delete('config')
      end
      super
    end

    # update resource
    def update
      if attributes['config']
        attributes['config'].each do |key, value|
          attributes["config.#{key}"] = value
        end
        attributes.delete('config')
      end
      super
    end
  end
end
