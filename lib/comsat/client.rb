module Comsat
  class Client
    attr_accessor :routes

    def initialize
      @@routes = []
    end

    def routes
      @@routes
    end

    # Public: Create a route for the specified services
    #
    # route - Name of the route we want to create
    # event_type - Tie this route to a specific event type (notice, alert, resolve)
    # services - An array of service url's
    #
    # Examples
    #
    #   client.create_route("my_route", [campfire://localhost, pagerduty://localhost])
    #
    # Returns the created route object
    def create_route(route, event_type=nil, services)
      start = Time.now
      Comsat.log(:fn => :create_route, :route => "#{route}", :at => :start)
      unless routes.detect {|r| r.name == route }
        routes << Route.new(route, event_type, services)
      end
      Comsat.log(:fn => :create_route, :route => "#{route}", :at => :finish, :elapsed => Time.now - start)
    end

    # Public: Notify a particular route
    #
    # route - Name of the route we want to notify
    # msg   - Message payload (Hash)
    #   message - The actual test of the message
    #   message_id - unique identifier for the message
    #   source - The source of the message (helps identify where it came from)
    #   message_type - Event type, notice, alert or resolve (optional)
    #
    # Examples
    #
    #   client.notify("my_route", {:message => "my message", :message_id =>
    #   "unique id", :source => "me", :message_type => "notice"})
    #
    # Returns nil
    def notify(route, msg={})
      message = msg.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

      start = Time.now
      Comsat.log(:fn => :notify, :route => "#{route}", :at => :start)
      notify_route = @@routes.detect {|r| r.name == route } if message

      if notify_route.event_type
        event = notify_route.event_type
      elsif message[:message_type]
        event = message[:message_type]
      else
        event = "notice"
      end

      notify_route.services[event].each do |svc|
        Comsat.log(:fn => :notify, :service => "#{svc.class.to_s.downcase}", :event => event)
        svc.send("send_#{event}".to_sym, message)
      end
      Comsat.log(:fn => :notify, :route => "#{route}", :at => :finish, :elapsed => Time.now - start)
    end
  end
end
