# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Notification
    class Notification
      VALUE_SEPARATOR = '|'
      DEFAULT_ALGORITHM = 'sha256'

      def initialize(signature:, body:, secret_key:)
        @signature  = signature
        @body       = body
        @secret_key = secret_key
      end

      def valid?
        signature == hmac
      end

      private

      attr_reader :signature, :body, :secret_key

      def hmac
        digest = OpenSSL::Digest.new(DEFAULT_ALGORITHM)
        OpenSSL::HMAC.hexdigest(digest, secret_key, data)
      end

      def data
        [
          body['amount']['currency'],
          body['amount']['value'],
          body['billId'],
          body['siteId'],
          body['status']['value']
        ].map(&:to_s).join(VALUE_SEPARATOR)
      end
    end
  end
end
