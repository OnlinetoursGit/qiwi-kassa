# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Bill
    class Bill < Resource
      def create(id:, params: {})
        @client.put(endpoint: "bills/#{id}",
                    payload: JSON.fast_generate(params))
      end

      def status(id:)
        @client.get(endpoint: "bills/#{id}")
      end

      def reject(id:)
        @client.post(endpoint: "bills/#{id}")
      end
    end
  end
end
