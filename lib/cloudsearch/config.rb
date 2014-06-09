module Cloudsearch
  class Config

    DEFAULTS = {
      :protocol       => 'https://',
      :admin_endpoint => 'cloudsearch.us-east-1.amazonaws.com',
      :version        => '2011-02-01',
      :service        => 'cloudsearch',
      :region         => 'us-east-1'
    }

    class << self

      def load(file, env = nil)
        env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development' 

        @config ||= YAML.load_file(file)[env].inject({}){|r,(k,v)| r[k.to_sym] = v; r}

        @config[:search_endpoint] = "search-#{@config[:endpoint]}"
        @config[:doc_endpoint]    = "doc-#{@config[:endpoint]}"

        @config = DEFAULTS.merge(@config)

        @config.keys.each do |m|
          define_singleton_method(m) { @config[m]}
        end

        @config.freeze
      end

      def url(endpoint = @config[:admin_endpoint])
        @config[:protocol] + endpoint
      end

      def host
        @config[:admin_endpoint]
      end

      def search_endpoint
        @config[:search_endpoint]
      end

      def all
        @config
      end

    end

  end
end
