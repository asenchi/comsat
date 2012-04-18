module Comsat
  class Client
    attr_accessor :routes

    def initialize
      @@routes = []
    end

    def routes
      @@routes
    end

    def create_route(route, event_type=nil, services)
      start = Time.now
      Comsat.log(:fn => :create_route, :route => "#{route}", :at => :start)
      unless routes.detect {|r| r.name == route }
        routes << Route.new(route, event_type, services)
      end
      Comsat.log(:fn => :create_route, :route => "#{route}", :at => :finish, :elapsed => Time.now - start)
    end

    def notify(route, msg={})
      message = msg.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      if notify_route.event_type
        event = notify_route
      elsif message[:message_type]
        event = message[:message_type]
      else
        event = "notice"
      end

      start = Time.now
      Comsat.log(:fn => :notify, :route => "#{route}", :at => :start)
      notify_route = @@routes.detect {|r| r.name == route } if message
      notify_route.services.each do |svc|
        Comsat.log(:fn => :notify, :service => "#{svc.class.to_s.downcase}", :event => event)
        svc.send("send_#{event}".to_sym, message)
      end
      Comsat.log(:fn => :notify, :route => "#{route}", :at => :finish, :elapsed => Time.now - start)
    end
  end
end
