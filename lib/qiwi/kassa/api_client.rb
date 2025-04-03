# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::ApiClient
    class ApiClient
      TIMEOUT = 70

      def initialize(secret_key:, provider:, host:)
        @default_headers = {
          'Content-Type': 'application/json;charset=UTF-8',
          Accept: 'application/json',
          Authorization: "Bearer #{secret_key}"
        }
        @host = host
      end

      def get(endpoint:, custom_headers: {})
        make_request do
          connection.get(endpoint, {}, @default_headers.merge(custom_headers))
        end
      end

      def post(endpoint:, payload: nil, custom_headers: {})
        make_request do
          connection.post(endpoint, payload, @default_headers.merge(custom_headers))
        end
      end

      def put(endpoint:, payload: nil, custom_headers: {})
        make_request do
          connection.put(endpoint, payload, @default_headers.merge(custom_headers))
        end
      end

      private

      def connection
        @connection ||= Faraday::Connection.new(@host) do |c|
          c.options.timeout = TIMEOUT
        end
      end

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
