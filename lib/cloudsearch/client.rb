module Cloudsearch
  class Client
    attr_accessor :action, :params

    def describe_domains
      @params = {}
      @action = 'describe_domains'

      send_auth_request
    end

    # method DefineIndexField
    # options [Hash]
    #   +:index_field *required [Hash]
    #     +:index_name *required [String]
    #     +:index_type *required [uint | literal | text] 
    #     +:literal_options *optional [Hash]
    #       +:default *optional [String] [0-1024]
    #       +:facet_enabled  *optional [Boolean] [default:false]
    #       +:result_enabled *optional [Boolean] [default:false]
    #       +:search_enabled *optional [Boolean] [default:false]
    #     +:text_options *optional [Hash]
    #       +:default *optional [String] [0-1024]
    #       +:facet_enabled  *optional [Boolean] [default:false]
    #       +:result_enabled *optional [Boolean] [default:false]
    #     +:uint_options *optional [Hash]
    #       +:default *optional [Integer] 
    def define_index_field options = {}
      @params = {}

      @action = 'define_index_field'
      locals  = Locals.fetch(action)
      options = check_required_fields(options, locals)

      build_params(locals, options)
      send_auth_request
    end

    # method IndexDocuments
    # Index the documents on amazon
    def index_documents
      @params = {}
      @action = 'index_documents'
      
      send_auth_request
    end

    def search options = {}
      request = Request.new(:get) do |req|
        req.params = options 
        req.suburl = "/#{Config.version}/search"
      end
      request.send_request(Config.url(Config.search_endpoint))
    end

    private

    # Send request API along with params
    def send_auth_request 
      request = AuthorizeRequest.new(:get, action_to_call) do |req|
        req.request_params = params
      end
      request.send_request(Config.url)
    end

    # Check for required fields. If the required fields from locals are not present in
    # given input options then push the fields with default values.
    def check_required_fields(options, locals)
      input_fields = options.values[0].inject({}){|r,(k,v)| r[k.to_s] = v; r}
      required_fields = locals['required']

      required_fields.each_pair do |k,v|
        unless input_fields.has_key?(k) 
          raise MissingFieldError.new("#{k} is required") if v.nil? 
          options.values[0][k] = v 
        end
      end
      return options
    end

    # Build the params to send the request API. Replace the keys from the locals.
    def build_params(locals, options)
      options.each_pair do |key,values|
        k_locals = locals[key.to_s] 
        parse(k_locals, values, k_locals['name'])
      end
    end

    def parse(k_locals, value, prefix)
      value.each_pair do |k,v|
        if v.kind_of? Hash
          parse(k_locals[k.to_s], v, "#{prefix}.#{k_locals[k.to_s]['name']}")
        else
          params["#{prefix}.#{k_locals[k.to_s]}"] = v
        end
      end
    end

    def action_to_call
      action.split(/_/).collect!{ |w| w.capitalize}.join
    end
  end
end
