module Kong
  class Plugin
    include Base
    include BelongsToApi

    ATTRIBUTE_NAMES = %w(id api_id name config enabled consumer_id).freeze
    API_END_POINT = '/plugins/'.freeze
  end
end
