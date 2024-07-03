class Metric < ApplicationRecord
    scope :by_minute, -> { group_by_period(:minute, :timestamp)}
    scope :by_hour, -> { group_by_period(:hour, :timestamp) }
    scope :by_day, -> { group_by_period(:day, :timestamp) }

    private

    def self.group_by_period(period, column)
      case period
      when :minute
        select("DATE_TRUNC('minute', #{column}) as period, AVG(value) as average_value, name").group("period", "name")
      when :hour
        select("DATE_TRUNC('hour', #{column}) as period, AVG(value) as average_value, name").group("period", "name")
      when :day
        select("DATE_TRUNC('day', #{column}) as period, AVG(value) as average_value, name").group("period", "name")
      end
    end
end

