module Comsat
  class PagerDuty < Service::Base
    PAGERDUTY_ENDPOINT = 'https://events.pagerduty.com/generic/2010-04-15/create_event.json'

    def send_notice(data)
      contact_pagerduty(:trigger, data)
    end
    alias :send_alert :send_notice

    def send_resolve(data)
      contact_pagerduty(:resolve, data)
    end

    private

    def contact_pagerduty(event_type, data)
      id         = data[:message_id] || SecureRandom.uuid
      message    = data[:message]
      source     = data[:source]
      message = "#{source}: #{message}"

      data = {
        :service_key => @credentials.api_key,
        :incident_key => id,
        :event_type => event_type,
        :description => message
      }
      RestClient.post PAGERDUTY_ENDPOINT, data.to_json, :content_type => :json
    end
  end
end
