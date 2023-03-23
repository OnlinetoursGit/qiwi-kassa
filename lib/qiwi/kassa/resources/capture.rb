# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Capture
    class Capture < Resource
      # https://developer.qiwi.com/ru/payments/#capture
      def create(site_id:, payment_id:, capture_id:)
        @client.put(endpoint: "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/captures/#{capture_id}",
                    payload: '{}')
      end

      # https://developer.qiwi.com/ru/payments/#capture_get
      def status(site_id:, payment_id:, capture_id:)
        @client.get(endpoint: "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      end
    end
  end
end
