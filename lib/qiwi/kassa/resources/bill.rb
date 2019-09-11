# frozen_string_literal: true

module Qiwi
  module Kassa
    class Bill < Resource
      def create(id, params = {})
        @client.put("bills/#{id}", JSON.fast_generate(params))
      end

      def status(id)
        @client.get("bills/#{id}")
      end

      def reject(id)
        @client.post("bills/#{id}", '')
      end
    end
  end
end
