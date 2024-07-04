class Metric < ApplicationRecord
    scope :by_all, -> { group_by_period(:all, :timestamp)}
    scope :by_minute, -> { group_by_period(:minute, :timestamp)}
    scope :by_hour, -> { group_by_period(:hour, :timestamp) }
    scope :by_day, -> { group_by_period(:day, :timestamp) }

    private

    def self.group_by_period(period, column)
      case period
      when :all
        select("#{column} AS period, value as average_value, name").order("period DESC")
      when :minute
        select("DATE_TRUNC('minute', #{column}) as period, AVG(value) as average_value, name").group("period", "name").order("period DESC")
      when :hour
        select("DATE_TRUNC('hour', #{column}) as period, AVG(value) as average_value, name").group("period", "name").order("period DESC")
      when :day
        select("DATE_TRUNC('day', #{column}) as period, AVG(value) as average_value, name").group("period", "name").order("period DESC")
      end
    end
end

