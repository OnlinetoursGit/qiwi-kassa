# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::ApiClient
    class ApiClient
      def initialize(secret_key:, provider:)
        @default_headers = {
          'Content-Type': 'application/json;charset=UTF-8',
          Accept: 'application/json',
          Authorization: "Bearer #{secret_key}"
        }
        @provider = provider
      end

      def get(endpoint:, host: API_HOSTS[@provider], custom_headers: {})
        make_request do
          Faraday.get("#{host}/#{endpoint}", {}, @default_headers.merge(custom_headers))
        end
      end

      def post(endpoint:, host: API_HOSTS[@provider], payload: nil, custom_headers: {})
        make_request do
          Faraday.post("#{host}/#{endpoint}", payload, @default_headers.merge(custom_headers))
        end
      end

      def put(endpoint:, host: API_HOSTS[@provider], payload: nil, custom_headers: {})
        make_request do
          Faraday.put("#{host}/#{endpoint}", payload, @default_headers.merge(custom_headers))
        end
      end

      private

      def make_request
        response = yield
        JSON.parse(response.body)
      rescue StandardError => e
        raise ApiException, "Message: #{e.message}"
      end

      def with_retries(retries_count = 5, timeout = 5)
        retries_count -= 1
        response = yield
        JSON.parse(response.body)
      rescue StandardError => e
        raise ApiException, "Message: #{e.message}. Number of connection tries exceed." unless retries_count.positive?

        sleep(timeout)
        retry
      end
    end
  end
end
