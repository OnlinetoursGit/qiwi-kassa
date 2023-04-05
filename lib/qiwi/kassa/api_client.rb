# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::ApiClient
    class ApiClient
      def initialize(secret_key:)
        @default_headers = {
          'Content-Type': 'application/json;charset=UTF-8',
          Accept: 'application/json',
          Authorization: "Bearer #{secret_key}"
        }
      end

      def get(url: API_URL, endpoint:, custom_headers: {})
        make_request do
          Faraday.get("#{url}#{endpoint}", {}, @default_headers.merge(custom_headers))
        end
      end

      def post(url: API_URL, endpoint:, payload: nil, custom_headers: {})
        make_request do
          Faraday.post("#{url}#{endpoint}", payload, @default_headers.merge(custom_headers))
        end
      end

      def put(url: API_URL, endpoint:, payload: nil, custom_headers: {})
        make_request do
          Faraday.put("#{url}#{endpoint}", payload, @default_headers.merge(custom_headers))
        end
      end

      private

      def make_request
        response = yield
        raise StandardError.new("Unauthorized request") if response.status == 401
        response_body = JSON.parse(response.body)
        response_body
      rescue => e
        raise ApiException, "Message: #{e.message}"
      end

      def with_retries(retries_count = 5, timeout = 5)
        retries_count -= 1
        response = yield
        raise StandardError.new("Unauthorized request") if response.status == 401
        response_body = JSON.parse(response.body)
        response_body
      rescue => e
        raise ApiException, "Message: #{e.message}. Number of connection tries exceed." unless retries_count > 0
        sleep(timeout)
        retry
      end
    end
  end
end
