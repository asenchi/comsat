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
end
