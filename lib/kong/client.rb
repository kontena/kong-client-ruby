
require 'json'
require 'excon'
require_relative './error'

module Kong
  class Client

    attr_accessor :default_headers, :http_client, :api_url

    # Initialize api client
    #
    def initialize(url = nil)
      Excon.defaults[:ssl_verify_peer] = false if ignore_ssl_errors?
      if url
        @api_url = url
      else
        @api_url = self.class.api_url
      end
      @http_client = Excon.new(@api_url, omit_default_port: true)
      @default_headers = { 'Accept' => 'application/json' }
      @collections = {}
    end

    def self.api_url
      @api_url || ENV['KONG_URI'] || 'http://localhost:8001'
    end

    def self.api_url=(url)
      @api_url = url
      @instance = self.new
    end

    def self.instance
      @instance ||= self.new
    end

    def consumers
      collection(Consumer)
    end

    def apis
      collection(Api)
    end

    def oauth_apps
      collection(OAuthApp)
    end

    def oauth2_tokens
      collection(OAuth2Token)
    end

    def plugins
      collection(Plugin)
    end

    def targets
      collection(Target)
    end

    def info
      get('/')
    end

    def status
      get('/status')
    end

    def cluster
      get('/cluster')
    end

    def version
      self.info['version'] rescue nil
    end

    def remove_node(name)
      delete("/cluster/nodes/#{name}")
    end


    # Get request
    #
    # @param [String] path
    # @param [Hash,NilClass] params
    # @param [Hash] headers
    # @return [Hash]
    def get(path, params = nil, headers = {})
      response = http_client.get(
        path: path,
        query: encode_params(params),
        headers: request_headers(headers)
      )
      if response.status == 200
        parse_response(response)
      else
        handle_error_response(response)
      end
    end

    # Post request
    #
    # @param [String] path
    # @param [Object] obj
    # @param [Hash] params
    # @param [Hash] headers
    # @return [Hash]
    def post(path, obj, params = {}, headers = {})
      request_headers = request_headers(headers)
      request_options = {
          path: path,
          headers: request_headers,
          body: encode_body(obj, request_headers['Content-Type']),
          query: encode_params(params)
      }
      response = http_client.post(request_options)
      if [200, 201].include?(response.status)
        parse_response(response)
      else
        handle_error_response(response)
      end
    end

    # Put request
    #
    # @param [String] path
    # @param [Object] obj
    # @param [Hash] params
    # @param [Hash] headers
    # @return [Hash]
    def patch(path, obj, params = {}, headers = {})
      request_headers = request_headers(headers)
      request_options = {
          path: path,
          headers: request_headers,
          body: encode_body(obj, request_headers['Content-Type']),
          query: encode_params(params)
      }

      response = http_client.patch(request_options)
      if [200, 201].include?(response.status)
        parse_response(response)
      else
        handle_error_response(response)
      end
    end


    # Put request
    #
    # @param [String] path
    # @param [Object] obj
    # @param [Hash] params
    # @param [Hash] headers
    # @return [Hash]
    def put(path, obj, params = {}, headers = {})
      request_headers = request_headers(headers)
      request_options = {
          path: path,
          headers: request_headers,
          body: encode_body(obj, request_headers['Content-Type']),
          query: encode_params(params)
      }

      response = http_client.put(request_options)
      if [200, 201].include?(response.status)
        parse_response(response)
      else
        handle_error_response(response)
      end
    end

    # Delete request
    #
    # @param [String] path
    # @param [Hash,String] body
    # @param [Hash] params
    # @param [Hash] headers
    # @return [Hash]
    def delete(path, body = nil, params = {}, headers = {})
      request_headers = request_headers(headers)
      request_options = {
          path: path,
          headers: request_headers,
          body: encode_body(body, request_headers['Content-Type']),
          query: encode_params(params)
      }
      response = http_client.delete(request_options)
      unless response.status == 204
        handle_error_response(response)
      end
    end

    private

    def collection(klass)
      @collections[klass.name] || @collections[klass.name] = Collection.new(klass, self)
    end

    ##
    # Get request headers
    #
    # @param [Hash] headers
    # @return [Hash]
    def request_headers(headers = {})
      @default_headers.merge(headers)
    end

    ##
    # Encode body based on content type
    #
    # @param [Object] body
    # @param [String] content_type
    def encode_body(body, content_type)
      if content_type == 'application/json'
        dump_json(body)
      else
        body
      end
    end

    def encode_params(params)
      return nil if params.nil?
      URI.encode_www_form(params)
    end

    ##
    # Parse response
    #
    # @param [HTTP::Message]
    # @return [Object]
    def parse_response(response)
      if response.headers['Content-Type'].include?('application/json')
        parse_json(response.body)
      else
        response.body
      end
    end

    ##
    # Parse json
    #
    # @param [String] json
    # @return [Hash,Object,NilClass]
    def parse_json(json)
      JSON.parse(json) rescue nil
    end

    ##
    # Dump json
    #
    # @param [Object] obj
    # @return [String]
    def dump_json(obj)
      JSON.dump(obj)
    end

    def ignore_ssl_errors?
      ENV['SSL_IGNORE_ERRORS'] == 'true'
    end

    def handle_error_response(response)
      message = response.body
      if response.status == 404 && message == ''
        message = 'Not found'
      end
      raise Error.new(response.status, message)
    end
  end
end
