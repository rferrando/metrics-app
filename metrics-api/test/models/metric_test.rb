require 'test_helper'

class MetricTest < ActiveSupport::TestCase
  def setup
    @local_timezone = ActiveSupport::TimeZone.new("UTC")
    local_date = Time.new(2024, 7, 01, 18, 25, 20, @local_timezone)
    @local_date_utc = local_date.getutc
    Time.stubs(:current).returns(@local_date_utc)
    Time.stubs(:now).returns(@local_date_utc)

    @metric = Metric.new(name: 'cpu', value: 75)
  end

  test "should set timestamp to Time.current if nil" do
    @metric.timestamp = nil
    @metric.save
    assert_not_nil @metric.timestamp
    assert_equal '2024-07-01 18:25:20', @metric.timestamp.strftime("%Y-%m-%d %H:%M:%S")
  end

  test "should set minute_precision correctly" do
    @metric.timestamp = Time.new(2024, 6, 30, 18, 25, 0, @local_timezone)
    @metric.save
    assert_equal @metric.minute_precision, Time.new(2024, 6, 30, 18, 25, 0, @local_timezone)
  end

  test "should set hour_precision correctly" do
    @metric.timestamp = Time.new(2024, 6, 30, 18, 25, 0, @local_timezone)
    @metric.save
    assert_equal @metric.hour_precision, Time.new(2024, 6, 30, 18, 0, 0, @local_timezone)
  end

  test "should set day_precision correctly" do
    @metric.timestamp = Time.new(2024, 6, 30, 18, 25, 0, @local_timezone)
    @metric.save
    assert_equal @metric.day_precision, Time.new(2024, 6, 30, 0, 0, 0, @local_timezone)
  end
end