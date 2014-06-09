require 'time'
# Copyright 2011-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.
#
# DOC: 
#   http://docs.amazonwebservices.com/general/latest/gr/signature-version-4.html

module Cloudsearch
  module Signature

    SIGN_ALGORITHM = 'AWS4-HMAC-SHA256'

    def add_authorization! credentials = {}
      datetime = Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
      headers['Host'] =  Config.host
      authorization(credentials, datetime)
    end

    protected

    def authorization credentials, datetime
      hex16(signature(credentials, datetime))
    end

    def signature credentials, datetime
      k_secret = Config.secret_access_key
      k_date = hmac("AWS4" + k_secret, datetime[0,8])
      k_region = hmac(k_date, Config.region)
      k_service = hmac(k_region, Config.service)
      k_credentials = hmac(k_service, 'aws4_request')
      hmac(k_credentials, string_to_sign(datetime))
    end

    def string_to_sign datetime
      parts = []
      parts << 'AWS4-HMAC-SHA256'
      parts << datetime
      parts << credential_string(datetime)
      parts << hex16(hash(canonical_request))
      parts.join("\n")
    end

    def credential_string datetime
      parts = []
      parts << datetime[0,8]
      parts << Config.region
      parts << Config.service
      parts << 'aws4_request'
      parts.join("/")
    end

    def canonical_request
      parts = []
      parts << http_method
      parts << '/' 
      parts << querystring
      parts << canonical_headers + "\n"
      parts << signed_headers.downcase
      parts << hex16(hash(body || ''))
      parts.join("\n")
    end

    def service
      # this method is implemented in the request class for each service
      raise NotImplementedError
    end

    def signed_headers
      to_sign = headers.keys.map{|k| k.to_s }
      to_sign.delete('version')
      to_sign.sort.join(";")
    end

    def canonical_headers
      canonical_header = []
      self.headers.each_pair do |k,v|
        canonical_header << [k.to_s,v] unless k.to_s == 'version'
      end
      canonical_header = canonical_header.sort_by(&:first)
      canonical_header.map{|k,v| "#{k.to_s.clone.downcase}:#{canonical_header_values(v)}" }.join("\n")
    end

    def canonical_header_values values
      values = [values] unless values.is_a?(Array)
      values.map(&:to_s).join(',').gsub(/\s+/, ' ').strip
    end

    def hex16 string
      string.unpack('H*').first
    end

    def hash string
      Digest::SHA256.digest(string)
    end

    # Computes an HMAC digest of the passed string.
    # @param [String] key
    # @param [String] value
    # @param [String] digest ('sha256')
    # @return [String]
    def hmac key, value, digest = 'sha256'
      OpenSSL::HMAC.digest(digest, key, value)
    end

    def credential(datetime)
      "#{Config.access_key_id}/#{datetime[0,8]}/#{Config.region}/#{Config.service}/aws4_request"
    end

  end
end
