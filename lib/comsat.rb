require "cgi"
require "comsat/version"
require "json"
require "rest_client"
require "securerandom"

module Comsat
  class Client
    def initialize(urls)
      @urls = urls
    end

    def send_notice(data)
      @urls.each do |url|
        ServiceFactory.create(url).send_notice(data)
      end
    end

    def send_alert(data)
      @urls.each do |url|
        ServiceFactory.create(url).send_alert(data)
      end
    end

    def send_resolve(data)
      @urls.each do |url|
        ServiceFactory.create(url).send_resolve(data)
      end
    end
  end

  class ServiceFactory
    def self.create(url)
      uri = URI.parse(url)
      case uri.scheme
      when 'campfire'
        Campfire.new(uri)
      when 'pagerduty'
        PagerDuty.new(uri)
      end
    end
  end

  class Campfire
    def initialize(uri)
      @acct = uri.host.split('.')[0]
      @api_key = uri.user
      @room = CGI.unescape(uri.path.gsub(/\A\//, ''))
    end

    def send_notice(data)
      # {:messages, :source, :message_id}
      messages = []
      messages << "[#{data[:source]}] #{data[:message]} :v:"
      send_message(messages)
    end
    alias :send_alert :send_notice
    alias :send_resolve :send_notice

    def send_message(msgs)
      unless room = find_room
        raise "Unable to find room"
      end
      Array(msgs).each {|line| room.speak line }
    end

    def campfire
      @campfire = ::Tinder::Campfire.new(
        @acct,
        :ssl => true,
        :token => @api_key
      )
    end

    def find_room
      campfire.find_room_by_name(@room)
    end
  end

  class PagerDuty
    ENDPOINT = 'https://events.pagerduty.com/generic/2010-04-15/create_event.json'
    
    def initialize(uri)
      @api_key = uri.user
    end

    def contact_pagerduty(event_type, data)
      id         = data[:message_id] || SecureRandom.uuid
      message    = data[:message]
      source     = data[:source]
      message = "#{source}: #{message}"

      data = { :service_key => @api_key, :incident_key => id, :event_type => event_type, :description => message }
      RestClient.post ENDPOINT, data.to_json, :content_type => :json
    end
    
    def send_notice(data)
      contact_pagerduty(:trigger, data)
    end
    alias :send_alert :send_notice

    def send_resolve(data)
      contact_pagerduty(:resolve, data)
    end
  end
end
