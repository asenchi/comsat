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
      start = Time.now
      Comsat.log(:fn => :create_route, :at => :start)
      unless routes.detect {|r| r.name == route }
        routes << Route.new(route, event_type, services)
      end
      Comsat.log(:fn => :create_route, :at => :finish, :elapsed => Time.now - start)
    end

    def notify(route, message={})
      start = Time.now
      Comsat.log(:fn => :notify, :at => :start)
      notify_route = @@routes.detect {|r| r.name == route } if message
      event = notify_route.event_type
      notify_route.services.each do |svc|
        Comsat.log(:fn => :notify, :service => "#{svc.class.to_s.downcase}", :event => event)
        svc.send("send_#{event}".to_sym, message)
      end
      Comsat.log(:fn => :notify, :at => :finish, :elapsed => Time.now - start)
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
  end
end
