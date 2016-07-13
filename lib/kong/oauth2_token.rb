require_relative './base'
module Kong
  class OAuth2Token
    include Base
    ATTRIBUTE_NAMES = %w(id credential_id expires_in created_at token_type access_token refresh_token scope authenticated_userid).freeze
    API_END_POINT = "/oauth2_tokens/".freeze

    # Get OAuthApp resource
    # @return [Kong::OAuthApp]
    def oauth_app
      Kong::OAuthApp.find_by_id(self.credential_id)
    end
  end
end
