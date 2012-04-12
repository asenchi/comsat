module Comsat
  module Log
    def self.start
      Scrolls::Log.start
    end

    def self.merge(data1, data2)
      data1.merge(data2)
    end

    def self.log(data, &blk)
      Scrolls.log(data, &blk)
    end
  end
end
