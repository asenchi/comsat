require "cgi"
require "json"
require "octokit"
require "pony"
require "rest_client"

require "comsat/client"
require "comsat/route"
require "comsat/service"
require "comsat/version"

require "comsat/helpers/auth_helper"

require "comsat/services/campfire"
require "comsat/services/failure"
require "comsat/services/github"
require "comsat/services/pagerduty"
require "comsat/services/sendgrid"

module Comsat

  def self.merge(data1, data2)
    data1.merge(data2)
  end

  # Public: Allows the user to specify a logger for the log messages that Comsat
  # produces.
  #
  # logger = The object you want logs to be sent too
  #
  # Examples
  #
  #   Comsat.instrument_with(STDOUT.method(:puts))
  #   # => #<Method: IO#puts>
  #
  # Returns the logger object
  def self.instrument_with(logger)
    @logger = logger
  end

  # Public: Turns on mocking mode
  #
  # Examples
  #
  #   Comsat.mock!
  #   # => true
  def self.mock!
    @mock = true
  end

  # Public: Checks if mocking mode is enabled
  #
  # Examples
  #
  #   Comsat.mocking?
  #   # => false
  #   Comsat.mock!
  #   Comsat.mocking?
  #   # => true
  #
  # Returns the state of mocking
  def self.mocking?
    !!@mock
  end

  # Public: Store mocked notifications
  #
  # Returns an Array of notifications
  def self.notifications
    @notifications ||= []
  end

  # Public: View the the currently instrumented logger
  #
  # Returns the logger object
  def self.logger
    @logger || STDOUT.method(:puts)
  end

  # Internal: Top level log method for use by Comsat
  #
  # data = Logging data (typically a hash)
  # blk  = block to execute
  #
  # Returns the response from calling the logger with the arguments
  def self.log(data, &blk)
    logger.call({:lib => :comsat}.merge(data), &blk)
  end

  # Public: Reset the mocked data
  #
  # Examples
  #
  #   Comsat.notifications
  #   # => [{..}]
  #   Comsat.reset!
  #   Comsat.notifications
  #   # => []
  def self.reset!
    @notifications = []
  end
end
