module Exceptions
    class NotValidError < StandardError
      def initialize(msg:)
        super(msg)
      end
    end

    class MetricNotFoundError < NotValidError
      def initialize
        super(msg: 'Missing metric: there is no data for that metric')
      end
    end

    class PeriodNotFoundError < NotValidError
      def initialize
        super(msg: 'Missing period: that periodo is not configured')
      end
    end
end