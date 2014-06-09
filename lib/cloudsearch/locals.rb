module Cloudsearch
  class Locals 

    class << self

      def load
        @locals ||= YAML.load_file(File.dirname(__FILE__) + "/locals/cloudsearch.yaml")
      end

      def fetch(action)
        raise MissingLocalsError unless @locals
        @locals["cloudsearch"]["actions"][action]
      end
    end
  end
end
