module Comsat
  class Route
    attr_accessor :name, :services, :event_type

    def initialize(route, et=nil, urls)
      @name = route
      @event_type = et

      @services = {
        "notice" => [],
        "alert" => [],
        "resolve" => []
      }

      urls.each do |url|
        svc = ServiceFactory.create(url)
        if svc.respond_to?("send_#{@event_type}")
          @services[@event_type] << svc
        else
          @services.keys.each do |k|
            @services[k] << svc
          end
        end
      end
    end

    def to_s
      "#<#{self.class} @name='#{@name}', @event='#{@event_type}', @services=#{@services.each {|s| s.to_s }}>"
    end
  end
end
