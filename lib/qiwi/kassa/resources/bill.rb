# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Bill
    class Bill < Resource
      def create(id:, params: {})
        @client.put(endpoint: "partner/bill/v1/bills/#{id}",
                    payload: JSON.fast_generate(params))
      end

      def status(id:)
        @client.get(endpoint: "partner/bill/v1/bills/#{id}")
      end

      def reject(id:)
        @client.post(endpoint: "partner/bill/v1/bills/#{id}/reject")
      end
    end
  end
end
