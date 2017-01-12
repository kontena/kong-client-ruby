module Kong
  class JWT
    include Base
    include BelongsToConsumer
    ATTRIBUTE_NAMES = %w(id key secret consumer_id).freeze
    API_END_POINT = '/jwt/'.freeze
  end
end
