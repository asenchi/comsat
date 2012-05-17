module Comsat
  # A simple Failure class to test mocking
  class Failure < Service::Base
    def send_notice(data)
      raise "Failure"
    end
    alias :send_alert :send_notice
    alias :send_resolve :send_notice
  end
end
