module Kong
  class Consumer
    include Base

    ATTRIBUTE_NAMES = %w(id custom_id username created_at).freeze
    API_END_POINT = '/consumers/'.freeze

    def delete
      self.oauth2_tokens.each do |token|
        token.delete
      end
      super
    end

    # List plugins
    #
    # @return [Array<Kong::Plugin>]
    def plugins
      Plugin.list({ consumer_id: self.id }, client: self.client)
    end

    # List OAuth applications
    #
    # @return [Array<Kong::OAuthApp>]
    def oauth_apps
      Collection.new(OAuthApp, self.client, "#{@api_end_point}#{self.id}/oauth2").all
    end

    # List KeyAuth credentials
    #
    # @return [Array<Kong::KeyAuth]
    def basic_auths
      Collection.new(BasicAuth, self.client, "#{@api_end_point}#{self.id}/basic-auth").all
    end

    # List KeyAuth credentials
    #
    # @return [Array<Kong::KeyAuth]
    def key_auths
      Collection.new(KeyAuth, self.client, "#{@api_end_point}#{self.id}/key-auth").all
    end

    # List OAuth2Tokens
    #
    # @return [Array<Kong::OAuth2Token>]
    def oauth2_tokens
      if self.custom_id
        OAuth2Token.list({ authenticated_userid: self.custom_id }, client: self.client)
      else
        []
      end
    end

    # List Acls
    #
    # @return [Array<Kong::Acl>]
    def acls
      Collection.new(Acl, self.client, "#{@api_end_point}#{self.id}/acls").all
    end

    # List JWTs
    #
    # @return [Array<Kong::JWT>]
    def jwts
      Collection.new(JWT, self.client, "#{@api_end_point}#{self.id}/jwt").all
    end
  end
end
