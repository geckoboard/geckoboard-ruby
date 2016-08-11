require 'net/http'
require 'json'

require 'geckoboard/version'
require 'geckoboard/client'
require 'geckoboard/errors'

module Geckoboard
  def self.client(api_key)
    Client.new(api_key)
  end
end
