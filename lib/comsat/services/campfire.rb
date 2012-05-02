module Comsat
  class Campfire < Service::Base
    def send_notice(data)
      # {:messages, :source, :message_id}
      messages = []
      messages << "[#{data[:source]}] #{data[:message]}"
      send_message(messages)
    end
    alias :send_alert :send_notice
    alias :send_resolve :send_notice

    private

    def send_message(msgs)
      unless room = find_room
        raise "Unable to find room"
      end
      Array(msgs).each {|line| speak(room["id"], line) }
    end

    def campfire
      @campfire = RestClient::Resource.new(
        "https://#{@credentials.api_key}:X@#{@credentials.host}",
        :headers => {:content_type => :json}
      )
    end

    def find_room
      if @credentials.scope.to_i > 0
        @room = {"id" => @credentials.scope.to_i}
      else

        begin
          rooms = JSON.parse(campfire['/rooms.json'].get)
        rescue RestClient::ServerBrokeConnection => e
          retries += 1
          raise if retries >= 3
          Comsat.log(:fn => :find_room, :at => :get_room, :error => e.class, :retry => retries)
          retry
        end

        @room = rooms["rooms"].select {|r| r["name"] == @credentials.scope }
        @room.first
      end
    end

    def speak(room, message)
      begin
        campfire["/room/#{room}/speak.json"].post(JSON.dump({:message => message}))
      rescue RestClient::ServerBrokeConnection => e
        retries += 1
        raise if retries >= 3
        Comsat.log(:fn => :speak, :at => :get_room, :error => e.class, :retry => retries)
        retry
      end
    end
  end
end
