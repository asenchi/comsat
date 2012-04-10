require "cgi"
require "json"
require "rest_client"
require "securerandom"
require "tinder"

require "comsat/service"
require "comsat/version"

require "comsat/helpers/auth_helper"

require "comsat/services/campfire"
require "comsat/services/pagerduty"

module Comsat
  class Client
    def initialize(urls)
      @urls = urls
    end

    def send_notice(data)
      send(data)
    end

    def send_alert(data)
      send(data)
    end

    def send_resolve(data)
      send(data)
    end

    private

    def send(data)
      @urls.each do |url|
        ServiceFactory.create(url).send_resolve(data)
      end
    end
  end
end
