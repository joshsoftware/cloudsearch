require 'cgi'

module Cloudsearch
  class Request
    include Signature

    HTTP_METHODS = {:get => 'GET', :put => 'PUT', 
      :post => 'POST', :delete => 'DELETE'}

    attr_accessor :action, :http_method, :headers, :params, :body, :domain, :request_params, :suburl

    def initialize(http_method = :post, action = '', &block)
      yield self if block_given?

      @http_method = HTTP_METHODS[http_method]
      @action = action
      @params ||= {}
      @request_params ||= {}
      @headers ||= {}
      @headers[:version] = Config.version
      @suburl ||= "/"
      @domain = Config.domain
    end

    def send_request(url)
      build_params
      
      conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded     
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end
      response = conn.send(@http_method.downcase)  do |req|
        req.url suburl 
        req.params = params
      end

      response.body
    end

    protected

    def querystring(signature = {})
      build_params(true)
      result = params.inject(""){|r, (k,v)| r << "#{k}=#{v}&"}
      result.chop!
    end

    def build_params(escape = false)
      params
    end

    def other_params(escape = false)
      datetime = Time.now.utc.strftime('%Y%m%dT%H%M%SZ')
      params['Version']             = Config.version 
      params['X-Amz-Algorithm']     = SIGN_ALGORITHM
      params['X-Amz-Credential']    = escape ? CGI.escape(credential(datetime)) : credential(datetime) 
      params['X-Amz-Date']          = datetime
      params['X-Amz-SignedHeaders'] = signed_headers
      return params
    end

  end
end
