module Comsat
  # A simple Failure class to test mocking
  class Sendgrid < Service::Base
    def send_notice(data)
      contact_sendgrid(data)
    end
    alias :send_alert :send_notice
    alias :send_resolve :send_notice

    private

    def contact_sendgrid(data)
      id = data[:message_id] || rand(100_000)
      message = data[:message]
      source = data[:source]
      message = "[#{source}] #{message}"

      Pony.mail(
        :from => "#{source}@comsat.notify",
        :to => @credentials.scope,
        :subject => message,
        :body => "Notification from Comsat\n\nMessage-ID: #{id}",
        :via => :smtp,
        :via_options => {
          :address => 'smtp.sendgrid.net',
          :port => '587',
          :user_name => sendgrid_user,
          :password => sendgrid_api_key,
          :authentication => :plain,
          :domain => "comsat.notify"
        }
      )
    end
 
    def sendgrid_url
      "https://#{@credentials.host}/api/mail.send.json"
    end

    def sendgrid_user
      @credentials.username
    end

    def sendgrid_api_key
      @credentials.password
    end
  end
end
