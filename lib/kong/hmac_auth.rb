module Kong
  class HmacAuth
    include Base
    include BelongsToConsumer

    ATTRIBUTE_NAMES = %w(id username consumer_id).freeze
    API_END_POINT = '/hmac-auth/'
  end
end
