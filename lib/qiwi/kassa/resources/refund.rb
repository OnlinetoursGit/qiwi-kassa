# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Refund
    class Refund < Resource
      def create(bill_id:, refund_id:, params: {})
        @client.put(endpoint: "bills/#{bill_id}/refunds/#{refund_id}",
                    payload: JSON.fast_generate(params))
      end

      def status(bill_id:, refund_id:)
        @client.get(endpoint: "bills/#{bill_id}/refunds/#{refund_id}")
      end
    end
  end
end
