class Metric < ApplicationRecord
  before_validation :set_default_timestamp
  validates :name, :value, :timestamp, presence: true
  before_save :set_precision_columns

  private

  def set_default_timestamp
    self.timestamp ||= Time.current
  end

  def set_precision_columns
    self.minute_precision = timestamp_change_precision('minute')
    self.hour_precision = timestamp_change_precision('hour')
    self.day_precision = timestamp_change_precision('day')
  end

  def timestamp_change_precision(precision)
    ActiveRecord::Base.connection.execute("SELECT DATE_TRUNC('#{precision}', TIMESTAMP '#{self.timestamp}')").first['date_trunc']
  end
end

