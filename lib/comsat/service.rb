module Comsat
  module Service
    class Base
      attr_reader :credentials

      def initialize(url)
        @credentials = Comsat::AuthHelper.parse(url)
      end

      def to_s
        "#<#{self.class} @host='#{@credentials.host}', @scope='#{@credentials.scope}'>"
      end
    end
  end

  class ServiceFactory
    def self.create(url)
      svc_name = URI.parse(url).scheme
      if Comsat.const_defined?(svc_name.capitalize)
        svc = Comsat.const_get(svc_name.capitalize)
        svc.new(url)
      end
    end
  end
end
