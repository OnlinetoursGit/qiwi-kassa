module Qiwi
  module Kassa
    class CaptureNotification < Notification
			def initialize(params)
        set_instances(self, params['capture'])
      end

      def success?
        valid? && !declined?
      end

      private

      def id
        capture_id
      end

      def declined?
        status['value'] == 'DECLINE'
      end
    end
  end
end
