# frozen_string_literal: true

require 'ostruct'
require 'rest_client'
require 'json'
require 'qiwi/kassa/client'
require 'qiwi/kassa/resource'
require 'qiwi/kassa/version'

Gem.find_files('qiwi/kassa/resources/*.rb').each { |path| require path }

module Qiwi
  module Kassa
    class QiwiKassaApiException < StandardError; end

    API_URL = 'https://api.qiwi.com/partner/bill/v1/'

    class Api
      attr_reader :resources

      def initialize(skey:, pkey:)
        client = Client.new(skey: skey)
        @resources = OpenStruct.new(
          bills: Bill.new(client: client),
          refunds: Refund.new(client: client)
        )
      end
    end
  end
end
