module Comsat
  class PagerDuty < Service::Base
    def send_notice(data)
      contact_pagerduty(:trigger, data)
    end
    alias :send_alert :send_notice

    def send_resolve(data)
      contact_pagerduty(:resolve, data)
    end

    private

    def contact_pagerduty(event_type, data)
      id         = data[:message_id] || rand(10_000)
      message    = data[:message]
      source     = data[:source]
      message = "[#{source}] #{message}"

      data = {
        :service_key => @credentials.api_key,
        :incident_key => id,
        :event_type => event_type,
        :description => message
      }
      RestClient.post "https://#{@credential.host}/#{@credential.scope}", data.to_json, :content_type => :json
    end
  end
end
