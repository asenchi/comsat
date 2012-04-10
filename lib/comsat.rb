require 'cgi'
require "comsat/version"

module Comsat
  class Client
    attr_accessor :urls

    def initialize(urls)
      self.urls = urls
    end

    def send_notice(data)
      urls.each do |url|
        ServiceFactory.create(url).send_notice(data)
      end
    end

    def send_alert(data)
      urls.each do |url|
        ServiceFactory.create(url).send_alert(data)
      end
    end

    def send_resolve(data)
      urls.each do |url|
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

    def send_alert(data)
    end

    def send_resolve(data)
    end

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
end
