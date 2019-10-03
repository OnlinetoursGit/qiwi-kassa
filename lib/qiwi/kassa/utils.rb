# frozen_string_literal: true

module Qiwi
  module Kassa
    # Qiwi::Kassa::Utils
    module Utils
      module_function

      def snake_case(str)
        str.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
      end

      def deep_transform_keys(object, &block)
        case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = deep_transform_keys(value, &block)
          end
        when Array
          object.map { |e| deep_transform_keys(e, &block) }
        else
          object
        end
      end
    end
  end
end
