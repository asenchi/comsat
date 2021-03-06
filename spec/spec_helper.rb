$: << File.expand_path("../../lib", __FILE__)

require 'comsat'
require 'scrolls'
require 'stringio'

Scrolls.init(:stream => StringIO.new)

module TestLogger
  def self.log(data, &blk)
    Scrolls.log(data, &blk)
  end
end

Comsat.instrument_with(TestLogger.method(:log))

RSpec.configure do |c|
  c.before(:all) do
    Comsat.mock!
  end

  c.before(:each) do
    Comsat.reset!
  end
end
