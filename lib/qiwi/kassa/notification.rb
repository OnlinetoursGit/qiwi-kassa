# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Notification
    class Notification
      VALUE_SEPARATOR = '|'
      DEFAULT_ALGORITHM = 'sha256'

      def initialize(signature:, data:, secret_key:)
        @data         = data
        @signature    = signature
        @secret_key   = secret_key
        @notification_type = Object.const_get("Qiwi::Kassa::#{data['type'].capitalize}Notification").new(serialized_data)
        @notification_type
      rescue NameError
        BillNotification.new(serialized_data)
      end

      private

      attr_reader :signature, :data, :secret_key, :notification_type

      def method_missing(method_name, *args, &block)
        if notification_type.respond_to?(method_name)
          notification_type.public_send(method_name)
        else
          super
        end
      end

      def valid?
        signature == hmac
      end

      def hmac
        digest = OpenSSL::Digest.new(DEFAULT_ALGORITHM)
        OpenSSL::HMAC.hexdigest(digest, secret_key, invoice_params)
      end

      def invoice_params
        [
          notification_type.id,
          notification_type.created_date_time,
          notification_type.amount['value']
        ].map(&:to_s).join(VALUE_SEPARATOR)
      end

      def serialized_data
        Utils.deep_transform_keys(data) { |k| Utils.snake_case(k) }
      end

      def set_instances(obj, params)
        obj.instance_exec(params) do
          params.each do |k, v|
            instance_variable_set("@#{k}", v)
            self.class.public_send(:attr_reader, k)
          end
        end
      end
    end
  end
end
