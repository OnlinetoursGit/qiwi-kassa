# frozen_string_literal: true

module Qiwi
  module Kassa
    class Client
      def initialize(skey:)
        @default_headers = {
          'Content-Type': 'application/json;charset=UTF-8',
          Accept: 'application/json',
          Authorization: "Bearer #{skey}"
        }
      end

      def get(endpoint, custom_headers = {})
        with_retries do
          RestClient.get("#{Qiwi::Kassa::API_URL}#{endpoint}", @default_headers.merge(custom_headers))
        end
      end

      def post(endpoint, payload, custom_headers = {})
        with_retries do
          RestClient.post("#{Qiwi::Kassa::API_URL}#{endpoint}", payload, @default_headers.merge(custom_headers))
        end
      end

      def put(endpoint, payload, custom_headers = {})
        with_retries do
          RestClient.put("#{Qiwi::Kassa::API_URL}#{endpoint}", payload, @default_headers.merge(custom_headers))
        end
      end

      private

      def with_retries(retries_count = 1, timeout = 1)
        retries_count -= 1
        response = yield
        response_body = JSON.parse(response.body)
        response_body
      rescue => e
        raise QiwiKassaApiException, "Message: #{e.message}. Number of connection tries exceed." unless retries_count > 0
        sleep(timeout)
        retry
      end
    end
  end
end
