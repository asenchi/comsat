require "cgi"
require "json"
require "rest_client"
require "scrolls"

require "comsat/client"
require "comsat/route"
require "comsat/service"
require "comsat/version"

require "comsat/helpers/auth_helper"

require "comsat/services/campfire"
require "comsat/services/pagerduty"

module Comsat
  Scrolls::Log.start

  def self.merge(data1, data2)
    data1.merge(data2)
  end

  def self.log(data, &blk)
    Scrolls.log(self.merge({:lib => :comsat}, data), &blk)
  end
end
