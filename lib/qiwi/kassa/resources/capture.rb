# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Bill
    class Capture < Resource
      def create(site_id:, payment_id:, capture_id:)
        @client.put(endpoint: "partner/payin/v1/sites/#{site_id}/payments/#{payment_id}/captures/#{capture_id}",
                    payload: '{}')
      end

      def status(site_id:, payment_id:, capture_id:)
        @client.get(endpoint: "/payin/v1/sites/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      end
    end
  end
end
