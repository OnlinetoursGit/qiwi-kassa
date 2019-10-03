module Qiwi
  module Kassa
    class PaymentNotification < Notification
			def initialize(params)
        set_instances(self, params['payment'])
      end

      def success?
        valid? && !declined?
      end

      private

      def id
        payment_id
      end

      def declined?
        status['value'] == 'DECLINE'
      end
    end
  end
end
