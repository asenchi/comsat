module Comsat
  module Service
    class Base
      def initialize(url)
        @credentials = Comsat::AuthHelper.parse(url)
      end
    end
  end
end
