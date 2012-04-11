module Comsat
  class Campfire < Service::Base
    def send_notice(data)
      # {:messages, :source, :message_id}
      messages = []
      messages << "[#{data[:source]}] #{data[:message]}"
      send_message(messages)
    end

    private

    def send_message(msgs)
      unless room = find_room
        raise "Unable to find room"
      end
      Array(msgs).each {|line| room.speak line }
    end

    def campfire
      @campfire = ::Tinder::Campfire.new(
        @credentials.host.split('.')[0],
        :ssl => true,
        :token => @credentials.api_key
      )
    end

    def find_room
      campfire.find_room_by_name(@credentials.scope)
    end
  end
end
