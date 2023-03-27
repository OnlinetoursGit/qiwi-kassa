# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Notification
    class Notification
      class NotificationException < StandardError; end

      VALUE_SEPARATOR = '|'
      DEFAULT_ALGORITHM = 'sha256'
      SUPPORTED_NOTIFICATION_TYPES = %w[PAYMENT CAPTURE REFUND]

      def initialize(data:)
        unless SUPPORTED_NOTIFICATION_TYPES.include?(data['type'])
          raise NotificationException, "Unsupported notification type: #{data['type']}."
        end

        define_instances serialized_data(data)
      end

      def success?
        status['value'] == 'SUCCESS'
      end

      def valid?(secret_key:, signature:)
        signature == hmac(secret_key)
      end

      def to_h
        Hash[instance_variables.map { |name| [name.to_s.delete('@'), instance_variable_get(name)] }]
      end

      def error
        {
          reason_code: status['reason_code'],
          reason_message: status['reason_message'],
          error_code: status['error_code']
        }
      end

      private

      attr_reader :payment_id, :capture_id, :refund_id

      def hmac(secret_key)
        digest = OpenSSL::Digest.new(DEFAULT_ALGORITHM)
        OpenSSL::HMAC.hexdigest(digest, secret_key, invoice_params)
      end

      def invoice_params
        [
          payment_id || capture_id || refund_id,
          created_date_time,
          amount['value']
        ].map(&:to_s).join(VALUE_SEPARATOR)
      end

      def serialized_data(data)
        Utils.deep_transform_keys(data) { |k| Utils.snake_case(k.to_s) }
      end

      def define_instances(data)
        type = data['type']&.downcase

        data[type].each do |k, v|
          instance_variable_set("@#{k}", v)
          self.class.send(:attr_reader, k)
        end
      end
    end
  end
end
