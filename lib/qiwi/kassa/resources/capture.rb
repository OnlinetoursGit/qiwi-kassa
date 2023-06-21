# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Capture
    class Capture < Resource
      # https://developer.qiwi.com/ru/payments/#capture
      def create(site_id:, payment_id:, capture_id:, params: {})
        @client.put(endpoint: "#{basic_path}/#{site_id}/payments/#{payment_id}/captures/#{capture_id}",
                    payload: JSON.fast_generate(params))
      end

      # https://developer.qiwi.com/ru/payments/#capture_get
      def status(site_id:, payment_id:, capture_id:)
        @client.get(endpoint: "#{basic_path}/#{site_id}/payments/#{payment_id}/captures/#{capture_id}")
      end
    end
  end
end
