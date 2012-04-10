require "cgi"
require "comsat/version"
require 'pagerduty'
require "securerandom"

module Comsat
  class Client
    def initialize(urls)
      @urls = urls
    end

    def send_notice(data)
      @urls.each do |url|
        puts 'run'
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
        CampfireService.new(uri)
      when 'pagerduty'
        PagerDutyService.new(uri)
      end
    end
  end

  class CampfireService
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

  class PagerDutyService
    def initialize(uri)
      @api_key = uri.user
    end

    def send_notice(data)
      message    = data[:message]
      source     = data[:source]
      
      message = "#{source}: #{message}"
      p = Pagerduty.new @api_key
      p.trigger message
    end
    alias :send_alert :send_notice
    alias :send_resolve :send_notice
  end
end
