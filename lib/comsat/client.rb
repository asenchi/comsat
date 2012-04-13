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
      log(:fn => :create_route) do
        unless routes.detect {|r| r.name == route }
          routes << Route.new(route, event_type, services)
        end
      end
    end

    def notify(route, message={})
      log(:fn => :notify) do
        notify_route = @@routes.detect {|r| r.name == route } if message
        event = notify_route.event_type
        notify_route.services.each do |svc|
          log(:fn => :notify, :service => "#{svc.class.to_s.downcase}", :event => event)
          svc.send("send_#{event}".to_sym, message)
        end
      end
    end

    def send_notice(data)
      send_event(:notice, data)
    end

    def send_alert(data)
      send_event(:alert, data)
    end

    def send_resolve(data)
      send_event(:resolve, data)
    end

    private

    def send_event(event_type, data)
      @urls.each do |url|
        service = ServiceFactory.create(url)
        if service.respond_to?("send_#{event_type}")
          service.send("send_#{event_type}".to_sym, data)
        else
          next
        end
      end
    end

    def log(data, &blk)
      Comsat.log(Comsat.merge({:ns => :client}, data), &blk)
    end
  end
end
