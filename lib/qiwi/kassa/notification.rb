# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Notification
    class Notification
      VALUE_SEPARATOR = '|'
      DEFAULT_ALGORITHM = 'sha256'

      def initialize(signature:, data:, secret_key:)
        @data         = serialized_data(data)
        @signature    = signature
        @secret_key   = secret_key
        define_instances
      end

      def success?
        valid? && !declined?
      end

      def declined?
        status['value'] == 'DECLINE'
      end

      def valid?
        signature == hmac
      end

      attr_reader(
        :type, :created_date_time, :status, :amount,
        :payment_method, :customer, :gateway_data, :bill_id, :flags
      )

      private

      attr_reader :signature, :data, :secret_key
      attr_reader :payment_id, :capture_id, :refund_id

      def hmac
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
        Utils.deep_transform_keys(data) { |k| Utils.snake_case(k) }
      end

      def define_instances
        type = data['type'].downcase

        data[type].each do |k, v|
          instance_variable_set("@#{k}", v)
        end
      end
    end
  end
end
