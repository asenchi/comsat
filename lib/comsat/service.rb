module Comsat
  class ServiceFactory
    def self.create(url)
      svc_name = URI.parse(url).scheme
      if Comsat.const_defined?(svc_name)
        svc = Comsat.const_get(svc_name)
        svc.new(url)
      end
    end
  end

  module Service
    class Base
      def initialize(url)
        @credentials = Comsat::AuthHelper.parse(url)
      end
    end
  end
end
