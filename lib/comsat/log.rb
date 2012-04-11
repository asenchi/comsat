module Comsat
  module Log
    def self.start
      Scrolls::Log.start
      log(ns: "log", fn: "start")
    end

    def self.merge(data1, data2)
      data1.merge(data2)
    end

    def self.log(data, &blk)
      Scrolls.log(merge({app: "comsat"}, data), &blk)
    end
  end
end
