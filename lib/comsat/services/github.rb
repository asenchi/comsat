module Comsat
  class Github < Service::Base
    def send_notice(data)
    end
    alias :send_alert :send_notice

    def send_resolve(data)
    end

    private

  end
end
