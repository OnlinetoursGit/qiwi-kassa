# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Notification
    class Notification
      VALUE_SEPARATOR = '|'
      DEFAULT_ALGORITHM = 'sha256'

      def initialize(data:)
        @data = serialized_data(data)
        define_instances
      end

      def success?
        status['value'] != 'DECLINE'
      end

      def valid?(secret_key:, signature:)
        signature == hmac(secret_key)
      end

      def bill?
        type.nil?
      end

      def to_h
        Hash[instance_variables.map { |name| [name.to_s.delete("@"), instance_variable_get(name)] } ]
      end

      def error
        {
          reason_code: status['reason_code'],
          reason_message: status['reason_message'],
          error_code: status['error_code']
        }
      end

      attr_reader(
        :type, :created_date_time, :status, :amount,
        :payment_method, :customer, :gateway_data, :bill_id, :flags
      )

      private

      attr_reader :data
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
        Utils.deep_transform_keys(data) { |k| Utils.snake_case(k) }
      end

      def define_instances
        type = data['type']&.downcase || 'bill'

        data[type].each do |k, v|
          instance_variable_set("@#{k}", v)
        end
      end
    end
  end
end
