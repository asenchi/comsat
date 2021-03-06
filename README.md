# Comsat

Notifications gem

This is the first iteration for making notifications easy to use from all
services. This is only a stop gap with a centralized service planned to manage
credentials and to keep from duplicating efforts.

Credentials are passed in a URL structure, for example, here is what a scheme
for Campfire might look like:

    campfire://<api_key>:X@blossom.campfirenow.com/Test%20Room

The schema name maps to the service name, the rest we pass to the service to
deal with.

## Routes

Routes allow the user to create aliases for contacting one or more services
for a specific event. An event is one of 'notice', 'alert' or 'resolve'.
Routes should be named according to their function, and initially are not
stored longer than a session, but will eventually be created and reside on
the server.

It is our intention to start developing usage patterns consistent with our
defined design goals.

The examples below show how routes are created.

## Messages

Messages should be one of three types, 'notice', 'alert', 'resolve'.

Messages are datum's that contain three pieces of information:

* message
* source
* message_id
* message_type

The 'source' is where this message originates, for example, "nagios". The
'message_id' should be a unique identifier for this message, and for certain
services should be used on alert/resolve messages to easily resolve them (i.e.
PagerDuty).

## Services

Each service should define three methods, one for each type of message:

* send_notice
* send_alert
* send_resolve

These provide the common interface between all of the services.

## Installation

Add this line to your application's Gemfile:

    gem 'comsat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install comsat

## Usage

```ruby
client = Comsat::Client.new
client.create_route("notify_on_exception", "notice", ["campfire://<api_key>:X@blossom.campfirenow.com/Test%20Room"])
client.notify("notify_on_exception", {
  :message => "Exception reached in #function",
  :source => "my_app",
  :message_id => "exception-#{rand(1_000)}"
})
```

Or you can specify routes without an 'event_type', instead specifying it in
the payload:

```ruby
client = Comsat::Client.new
client.create_route("notify_on_exception", ["campfire://<api_key>:X@blossom.campfirenow.com/Test%20Room"])
client.notify("notify_on_exception", {
  :message => "Exception reached in #function",
  :source => "my_app",
  :message_id => "exception-#{rand(1_000)}",
  :message_type => "notice"
})
```

You can also instrument Comsat with your favorite logger (which should be
Scrolls by now :)):

```ruby
require "scrolls"
require "comsat"

module MyLogger
  def self.log(data, &blk)
    Scrolls.log(data, &blk)
  end
end

Comsat.instrument_with(MyLogger.method(:log))
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
