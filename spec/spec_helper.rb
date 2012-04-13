$: << File.expand_path("../../lib", __FILE__)

require 'comsat'
require 'scrolls'
require 'stringio'

Scrolls::Log.start(StringIO.new)

module TestLogger
  def self.log(data, &blk)
    Scrolls.log(data, &blk)
  end
end

Comsat.instrument_with(TestLogger.method(:log))

RSpec.configure do |c|
end
