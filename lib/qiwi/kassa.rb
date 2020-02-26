# frozen_string_literal: true

require 'ostruct'
require 'rest_client'
require 'json'
require 'qiwi/kassa/api_client'
require 'qiwi/kassa/utils'
require 'qiwi/kassa/notification'
require 'qiwi/kassa/resource'
require 'qiwi/kassa/version'

Gem.find_files('qiwi/kassa/resources/*.rb').each { |path| require path }

module Qiwi
  module Kassa
    class ApiException < StandardError; end

    API_URL = 'https://api.qiwi.com/'

    # Qiwi::Kassa::Api
    class Api
      attr_reader :resources

      def initialize(secret_key:)
        client = Qiwi::Kassa::ApiClient.new(secret_key: secret_key)
        @resources = OpenStruct.new(
          bills: Qiwi::Kassa::Bill.new(client: client),
          refunds: Qiwi::Kassa::Refund.new(client: client),
          captures: Qiwi::Kassa::Capture.new(client: client)
        )
      end
    end

    # Qiwi::Kassa::PaymentForm
    class PaymentForm
      # @param params [Hash] request parameters
      # @example
      #   {
      #     publicKey: 'Fnzr1yTebUiQaBLDnebLMMxL8nc6FF5zfmGQnypc*******',
      #     amount: 100,
      #     billId: '893794793973',
      #     successUrl: 'https://test.ru',
      #     email: 'test@test.ru'
      #   }
      # @return [String]
      def self.build(params: {})
        url   = 'https://oplata.qiwi.com/create'
        query = RestClient::Utils.encode_query_string(params)

        "#{url}?#{query}"
      end
    end
  end
end
