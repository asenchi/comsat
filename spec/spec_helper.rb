$: << File.expand_path("../../lib", __FILE__)

require 'comsat'
require 'scrolls'
require 'stringio'

Scrolls::Log.start(StringIO.new)

RSpec.configure do |c|
end
