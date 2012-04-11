module Comsat
  class Route
    attr_accessor :name, :services, :event_type

    def initialize(route, et, urls)
      @name = route
      @event_type = et if %w(alert notice resolve).include?(et)
      @services = []
      urls.each do |url|
        svc = ServiceFactory.create(url)
        if svc.respond_to?("send_#{@event_type}")
          @services << svc
        else
          next
        end
      end
    end

    def to_s
      "#<#{self.class} @name='#{@name}', @event='#{@event_type}', @services=#{@services.each {|s| s.to_s }}>"
    end
  end
end
