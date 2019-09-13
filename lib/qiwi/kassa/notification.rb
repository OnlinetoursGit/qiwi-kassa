# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Notification
    class Notification
      VALUE_SEPARATOR = '|'
      DEFAULT_ALGORITHM = 'sha256'

      def self.check_signature(signature:, body:, secret_key:)
        data = [
          body['amount']['currency'],
          body['amount']['value'],
          body['billId'],
          body['siteId'],
          body['status']['value']
        ].map(&:to_s).join(VALUE_SEPARATOR)

        digest = OpenSSL::Digest.new(DEFAULT_ALGORITHM)
        hmac   = OpenSSL::HMAC.hexdigest(digest, secret_key, data)

        signature == hmac
      end
    end
  end
end
