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

      def http_post(url, payload, headers={}, &blk)
        retries = 0
        begin
          RestClient.post(url, payload, headers, &blk)
        rescue RestClient::ServerBrokeConnection => e
          retries += 1
          raise if retries >= 3
          Comsat.log(:fn => :http_post, :at => :exception, :error => e.class, :retry => retries)
          retry
        rescue RestClient::RequestTimeout
          raise
        end
      end

      def http_get(url, headers={}, &blk)
        begin
          RestClient.get(url, headers, &blk)
        rescue RestClient::ServerBrokeConnection => e
          retries += 1
          raise if retries >= 3
          Comsat.log(:fn => :http_get, :at => :exception, :error => e.class, :retry => retries)
          retry
        rescue RestClient::RequestTimeout
          raise
        end
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
