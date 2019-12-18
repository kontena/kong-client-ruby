module Kong
  class OAuthApp
    include Base
    include BelongsToConsumer
    ATTRIBUTE_NAMES = %w(id name client_id client_secret redirect_uri consumer_attrs).freeze
    API_END_POINT = "/oauth2/".freeze
  end
end
