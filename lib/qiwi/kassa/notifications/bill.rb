module Qiwi
  module Kassa
    class BillNotification < Notification
			def initialize(params)
        set_instances(self, params)
      end

      def success?
        valid? && !declined?
      end

      private

      def id
        bill_id
      end

      def declined?
        status['value'] == 'DECLINE'
      end
    end
  end
end
