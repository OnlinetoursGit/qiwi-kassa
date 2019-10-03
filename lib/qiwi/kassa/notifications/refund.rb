module Qiwi
  module Kassa
    class RefundNotification < Notification
			def initialize(params)
        set_instances(self, params['refund'])
      end

      def success?
        valid? && !declined?
      end

      private

      def id
        refund_id
      end

      def declined?
        status['value'] == 'DECLINE'
      end
    end
  end
end
