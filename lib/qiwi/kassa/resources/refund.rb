# frozen_string_literal: true

module Qiwi
  module Kassa
    class Refund < Resource
      def create(bill_id, refund_id, params = {})
        @client.put("bills/#{bill_id}/refunds/#{refund_id}", JSON.fast_generate(params))
      end

      def status(bill_id, refund_id)
        @client.get("bills/#{bill_id}/refunds/#{refund_id}")
      end
    end
  end
end
