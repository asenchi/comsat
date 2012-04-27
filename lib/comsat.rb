require "cgi"
require "json"
require "rest_client"

require "comsat/client"
require "comsat/route"
require "comsat/service"
require "comsat/version"

require "comsat/helpers/auth_helper"

require "comsat/services/campfire"
require "comsat/services/pagerduty"

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
end
