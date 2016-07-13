module Kong
  class KeyAuth
    include Base
    include BelongsToConsumer
    ATTRIBUTE_NAMES = %w(id key consumer_id).freeze
    API_END_POINT = "/key-auth/".freeze
  end
end
