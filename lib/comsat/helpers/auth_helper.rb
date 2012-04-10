require 'cgi'
require 'ostruct'
require 'uri'

module Comsat
  module AuthHelper

    def self.parse(url)
      parse_url(url)
      OpenStruct.new(to_hash)
    end

    def self.parse_url(url)
      @uri = URI.parse(url)
    end

    def self.to_hash
      {
        :name     => @uri.scheme,
        :api_key  => @uri.user,
        :username => @uri.user,
        :password => @uri.password,
        :host     => @uri.host,
        :scope    => CGI.unescape(@uri.path.gsub(/\A\//, ''))
      }
    end
  end
end
