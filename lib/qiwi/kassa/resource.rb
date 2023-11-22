# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Resource
    class Resource
      BASIC_PATHS = {
        qiwi: '/partner/payin/v1/sites',
        pay2me: '/payin/v1/sites'
      }.freeze

      def initialize(client:, provider:)
        @client = client
        @provider = provider
      end

      def basic_path
        BASIC_PATHS[@provider]
      end
    end
  end
end
