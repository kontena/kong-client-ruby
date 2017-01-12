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
      Plugin.list({ consumer_id: self.id })
    end

    # List OAuth applications
    #
    # @return [Array<Kong::OAuthApp>]
    def oauth_apps
      apps = []
      response = client.get("#{@api_end_point}#{self.username}/oauth2") rescue nil
      if response
        response['data'].each do |attributes|
          apps << Kong::OAuthApp.new(attributes)
        end
      end
      apps
    end

    # List KeyAuth credentials
    #
    # @return [Array<Kong::KeyAuth]
    def basic_auths
      apps = []
      response = client.get("#{@api_end_point}#{self.username}/basic-auth") rescue nil
      if response
        response['data'].each do |attributes|
          apps << Kong::BasicAuth.new(attributes)
        end
      end
      apps
    end

    # List KeyAuth credentials
    #
    # @return [Array<Kong::KeyAuth]
    def key_auths
      apps = []
      response = client.get("#{@api_end_point}#{self.username}/key-auth") rescue nil
      if response
        response['data'].each do |attributes|
          apps << Kong::KeyAuth.new(attributes)
        end
      end
      apps
    end

    # List OAuth2Tokens
    #
    # @return [Array<Kong::OAuth2Token>]
    def oauth2_tokens
      OAuth2Token.list({ authenticated_userid: self.custom_id })
    end

    # List JWTs
    #
    # @return [Array<Kong::JWT>]
    def jwts
      apps = []
      response = client.get("#{@api_end_point}#{self.username}/jwt") rescue nil
      if response
        response['data'].each do |attributes|
          apps << Kong::JWT.new(attributes)
        end
      end
      apps
    end
  end
end
