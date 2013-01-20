require 'cgi'
require 'open-uri'
require 'json'
require 'net/http'
require 'active_support/all'
require "blekko-search/version"
require "blekko-search/blekko"
require "blekko-search/search"
require "blekko-search/search_result"
require "blekko-search/slashtag"

module BlekkoSearch
  mattr_accessor :http_class
end