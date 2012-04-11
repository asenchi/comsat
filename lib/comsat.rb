require "cgi"
require "json"
require "rest_client"
require "scrolls"
require "securerandom"

# Service includes
require "tinder"

require "comsat/log"
require "comsat/route"
require "comsat/service"
require "comsat/version"

require "comsat/helpers/auth_helper"

require "comsat/services/campfire"
require "comsat/services/pagerduty"

module Comsat
  class Client

    attr_accessor :routes

    def initialize
      @@routes = []
    end

    def routes
      @@routes
    end

    def create_route(route, event_type, services)
      unless routes.detect {|r| r.name == route }
        routes << Route.new(route, event_type, services)
      end
    end

    def notify(route, message={})
      notify_route = @@routes.detect {|r| r.name == route } if message
      event = notify_route.event_type
      notify_route.services.each do |svc|
        svc.send("send_#{event}".to_sym, message)
      end
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
