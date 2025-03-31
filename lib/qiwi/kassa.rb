# frozen_string_literal: true

require 'ostruct'
require 'faraday'
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

    API_HOSTS = {
      qiwi: 'https://api.qiwi.com',
      pay2me: 'https://api.pay2me.com'
    }.freeze

    # Qiwi::Kassa::Api
    class Api
      attr_reader :client, :resources

      def initialize(secret_key:, provider: :qiwi, host:)
        @client = Qiwi::Kassa::ApiClient.new(secret_key: secret_key, provider: provider)
        @resources = OpenStruct.new(
          bills: Qiwi::Kassa::Bill.new(client: @client, provider: provider),
          refunds: Qiwi::Kassa::Refund.new(client: @client, provider: provider),
          captures: Qiwi::Kassa::Capture.new(client: @client, provider: provider)
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
        query = Faraday::Utils.build_query(params)

        "#{url}?#{query}"
      end
    end
  end
end
