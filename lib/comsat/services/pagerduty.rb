module Comsat
  class Pagerduty < Service::Base
    def send_notice(data)
      contact_pagerduty(:trigger, data)
    end

    def send_notice(data)
      contact_pagerduty(:acknowledge, data)
    end

    def send_resolve(data)
      contact_pagerduty(:resolve, data)
    end

    private

    def contact_pagerduty(event_type, data)
      id         = data[:message_id] || rand(10_000)
      message    = data[:message]
      source     = data[:source]
      message = "[#{source}] #{message}"

      pagerduty_url = "https://#{@credentials.host}/generic/2010-04-15/create_event.json"
      data = {
        :service_key => @credentials.api_key,
        :incident_key => id,
        :event_type => event_type,
        :description => message
      }
      http_post pagerduty_url, data.to_json, :content_type => :json
    end
  end
end
