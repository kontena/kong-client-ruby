module Kong
  class BasicAuth
    include Base
    include BelongsToConsumer
    ATTRIBUTE_NAMES = %w(id username password consumer_id).freeze
    API_END_POINT = "/basic-auth/".freeze
  end
end
