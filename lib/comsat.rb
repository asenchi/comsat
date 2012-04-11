require "cgi"
require "json"
require "rest_client"
require "scrolls"
require "securerandom"

# Service includes
require "tinder"

require "comsat/log"
require "comsat/service"
require "comsat/version"

require "comsat/helpers/auth_helper"

require "comsat/services/campfire"
require "comsat/services/pagerduty"

module Comsat
  class Client
    def initialize(*urls)
      @urls = urls
    end

    def send_notice(data)
      send(:notice, data)
    end

    def send_alert(data)
      send(:alert, data)
    end

    def send_resolve(data)
      send(:resolve, data)
    end

    private

    def send(event_type, data)
      @urls.each do |url|
        service = ServiceFactory.create(url)
        if service.respond_to?("send_#{event_type}")
          service.send("send_#{event_type}".to_sym, data)
        else
          next
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
