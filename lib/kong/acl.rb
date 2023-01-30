module Kong
  class Acl
    include Base
    include BelongsToConsumer
    ATTRIBUTE_NAMES = %w(id group tags consumer_id).freeze
    API_END_POINT = "/acls/".freeze
  end
end
