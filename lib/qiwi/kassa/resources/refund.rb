# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Refund
    class Refund < Resource
      # https://developer.qiwi.com/ru/payments/#refund-api
      def create(site_id:, payment_id:, refund_id:, params: {})
        @client.put(endpoint: "#{basic_path}/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}",
                    payload: JSON.fast_generate(params))
      end

      # https://developer.qiwi.com/ru/payments/#refund-api-status
      def status(site_id:, payment_id:, refund_id:)
        @client.get(endpoint: "#{basic_path}/#{site_id}/payments/#{payment_id}/refunds/#{refund_id}")
      end

      # https://developer.qiwi.com/ru/payments/#refunds-api-status
      def statuses(site_id:, payment_id:)
        @client.get(endpoint: "#{basic_path}/#{site_id}/payments/#{payment_id}/refunds")
      end
    end
  end
end
