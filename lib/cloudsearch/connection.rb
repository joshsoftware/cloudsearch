module Cloudsearch
  module Connection

    def sign_request(action, params = {})
      params['Action'] = action
      params['DomainName'] ||= Config[:serach_domain]
      params['X-Amz-Date'] = Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
    end

    private

    def canonical_query(params)
    end

    def string_to_sing(params)
    end

    def signature(config, datetime)
    end

  end
end
