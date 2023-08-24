# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Bill
    class Bill < Resource
      # https://developer.qiwi.com/ru/payments/#invoice_put
      def create(id:, site_id:, params: {})
        @client.put(endpoint: "#{basic_path}/#{site_id}/bills/#{id}",
                    payload: JSON.fast_generate(params))
      end

      # https://developer.qiwi.com/ru/payments/#invoice-details
      def status(id:, site_id:)
        @client.get(endpoint: "#{basic_path}/#{site_id}/bills/#{id}/details")
      end

      # https://developer.qiwi.com/ru/payments/#invoice-payments
      def payments(id:, site_id:)
        @client.get(endpoint: "#{basic_path}/#{site_id}/bills/#{id}")
      end
    end
  end
end
