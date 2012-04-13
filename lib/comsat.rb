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

  def self.instrument_with(logger)
    @logger = logger
  end

  def self.logger
    @logger
  end

  def self.log(data, &blk)
    logger.call({:lib => :comsat}.merge(data), &blk)
  end
end
