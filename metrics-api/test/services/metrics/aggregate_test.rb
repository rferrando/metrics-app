require 'test_helper'

class AggregateTest < ActiveSupport::TestCase
  setup do
    @local_timezone = ActiveSupport::TimeZone.new("UTC")
    local_date = Time.new(2024, 07, 01, 12, 30, 0, @local_timezone)
    Time.stubs(:current).returns(local_date.getutc)
    Time.stubs(:now).returns(local_date.getutc)
    Metric.create(name: 'cpu', value: 50, timestamp: '2024-06-30T18:26:00.000Z')
    Metric.create(name: 'cpu', value: 100, timestamp: '2024-06-30T18:26:10.000Z')
    Metric.create(name: 'mem', value: 907060, timestamp: '2024-06-30T18:29:00.000Z')
    Metric.create(name: 'mem', value: 906000, timestamp: '2024-06-30T18:40:20.000Z')
    @start_date = Time.new(2024, 06, 30, 00, 00, 00, @local_timezone)
    @end_date = Time.new(2024, 07, 30, 23, 59, 59, @local_timezone)
  end

  test 'compute aggregation functions by metric name and period' do
    Metrics::Aggregate.new.call('cpu', 'minute')
    cpu_minute_metric =  MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
    'cpu', 'minute', @start_date, @end_date)
    assert_equal 1, cpu_minute_metric.count
    cpu_minute_metric.each do |cpu_minute_metric|
      assert_equal 2, cpu_minute_metric['count']
      assert_equal '2024-06-30 18:26:59', cpu_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
      assert_equal 75.0, cpu_minute_metric['average_value']
      assert_equal 50.0, cpu_minute_metric['min_value']
      assert_equal 100.0, cpu_minute_metric['max_value']
      assert_equal 150.0, cpu_minute_metric['total_value']
    end

    Metrics::Aggregate.new.call('cpu', 'hour')
    cpu_hour_metric = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
    'cpu', 'hour', @start_date, @end_date)
    assert_equal 1, cpu_hour_metric.count
    cpu_hour_metric.each do |cpu_hour_metric|
      assert_equal 2, cpu_hour_metric['count']
      assert_equal '2024-06-30 18:59:59', cpu_hour_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
      assert_equal 75.0, cpu_hour_metric['average_value']
      assert_equal 50.0, cpu_hour_metric['min_value']
      assert_equal 100.0, cpu_hour_metric['max_value']
      assert_equal 150.0, cpu_hour_metric['total_value']
    end

    Metrics::Aggregate.new.call('cpu', 'day')
    cpu_day_metric = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
    'cpu', 'day', @start_date, @end_date)
    assert_equal 1, cpu_day_metric.count
    cpu_day_metric.each do |cpu_day_metric|
      assert_equal 2, cpu_day_metric['count']
      assert_equal '2024-06-30 23:59:59', cpu_day_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
      assert_equal 75.0, cpu_day_metric['average_value']
      assert_equal 50.0, cpu_day_metric['min_value']
      assert_equal 100.0, cpu_day_metric['max_value']
      assert_equal 150.0, cpu_day_metric['total_value']
    end

    Metrics::Aggregate.new.call('mem', 'minute')
    mem_minute_metric =  MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
    'mem', 'minute', @start_date, @end_date)
    assert_equal 2, mem_minute_metric.count
    mem_minute_metric.each_with_index do |mem_minute_metric, index|
      if index == 0
        assert_equal 1, mem_minute_metric['count']
        assert_equal '2024-06-30 18:29:59', mem_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 907060.0, mem_minute_metric['average_value']
        assert_equal 907060.0, mem_minute_metric['min_value']
        assert_equal 907060.0, mem_minute_metric['max_value']
        assert_equal 907060.0, mem_minute_metric['total_value']
      else
        assert_equal 1, mem_minute_metric['count']
        assert_equal '2024-06-30 18:40:59', mem_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 906000.0, mem_minute_metric['average_value']
        assert_equal 906000.0, mem_minute_metric['min_value']
        assert_equal 906000.0, mem_minute_metric['max_value']
        assert_equal 906000.0, mem_minute_metric['total_value']
      end  
    end

    Metrics::Aggregate.new.call('mem', 'hour')
    mem_hour_metric =  MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
    'mem', 'hour', @start_date, @end_date)
    assert_equal 1, mem_hour_metric.count
    mem_hour_metric.each do |mem_hour_metric|
        assert_equal 2, mem_hour_metric['count']
        assert_equal '2024-06-30 18:59:59', mem_hour_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 906530.0, mem_hour_metric['average_value']
        assert_equal 906000.0, mem_hour_metric['min_value']
        assert_equal 907060.0, mem_hour_metric['max_value']
        assert_equal 1813060.0, mem_hour_metric['total_value']
    end

    Metrics::Aggregate.new.call('mem', 'day')
    mem_day_metric =  MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
    'mem', 'day', @start_date, @end_date)
    assert_equal 1, mem_day_metric.count
    mem_day_metric.each do |mem_day_metric|
        assert_equal 2, mem_day_metric['count']
        assert_equal '2024-06-30 23:59:59', mem_day_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 906530.0, mem_day_metric['average_value']
        assert_equal 906000.0, mem_day_metric['min_value']
        assert_equal 907060.0, mem_day_metric['max_value']
        assert_equal 1813060.0, mem_day_metric['total_value']
    end
  end

  test 'updates existing aggregated metrics for a metric name when receiving new metrics 
    with a timestamp within a time resolution already computed' do
    assert_difference 'AggregatedMetric.count', 1 do
      Metrics::Aggregate.new.call('cpu', 'minute')
    end
    Metric.create(name: 'cpu', value: 60, timestamp: '2024-06-30T18:26:30.000Z')

    Metrics::Aggregate.new.call('cpu', 'minute')
    cpu_minute_metric = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
    'cpu', 'minute', @start_date, @end_date)
    assert_equal 1, cpu_minute_metric.count
    cpu_minute_metric.each do |cpu_minute_metric|
    assert_equal 3, cpu_minute_metric['count']
    assert_equal '2024-06-30 18:26:59', cpu_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
    assert_equal 70.0, cpu_minute_metric['average_value']
    assert_equal 50.0, cpu_minute_metric['min_value']
    assert_equal 100.0, cpu_minute_metric['max_value']
    assert_equal 210.0, cpu_minute_metric['total_value']
    end
  end

  test 'creates new aggregated metrics for a metric name when receiving new metrics 
    with a timestamp within a time resolution not yet computed' do
      assert_difference 'AggregatedMetric.count', 1 do
        Metrics::Aggregate.new.call('cpu', 'minute')
      end
      Metric.create(name: 'cpu', value: 60, timestamp: '2024-06-30T18:29:30.000Z')

      Metrics::Aggregate.new.call('cpu', 'minute')
      cpu_minute_metric = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
      'cpu', 'minute', @start_date, @end_date)
      assert_equal 2, cpu_minute_metric.count
      cpu_minute_metric.each_with_index do |cpu_minute_metric, index|
      if index == 0
        assert_equal 2, cpu_minute_metric['count']
        assert_equal '2024-06-30 18:26:59', cpu_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 75.0, cpu_minute_metric['average_value']
        assert_equal 50.0, cpu_minute_metric['min_value']
        assert_equal 100.0, cpu_minute_metric['max_value']
        assert_equal 150.0, cpu_minute_metric['total_value']
      else
        assert_equal 1, cpu_minute_metric['count']
        assert_equal '2024-06-30 18:29:59', cpu_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 60.0, cpu_minute_metric['average_value']
        assert_equal 60.0, cpu_minute_metric['min_value']
        assert_equal 60.0, cpu_minute_metric['max_value']
        assert_equal 60.0, cpu_minute_metric['total_value']
      end
    end
  end

  test 'the aggregation service has an incremental behaviour since only performs the computation for new metrics 
  created after or equal than the last aggregated time' do
      Metrics::Aggregate.new.call('cpu', 'minute')

      local_date = Time.new(2024, 8, 10, 12, 30, 0, @local_timezone)
      Time.stubs(:current).returns(local_date.getutc)
      Time.stubs(:now).returns(local_date.getutc)
      Metric.create(name: 'cpu', value: 60, timestamp: '2024-08-10T18:12:30.000Z')
      @start_date = Time.new(2024, 06, 30, 00, 00, 00, @local_timezone)
      @end_date = Time.new(2024, 8, 13, 23, 59, 59, @local_timezone)
      Metrics::Aggregate.new.call('cpu', 'minute')

      local_date = Time.new(2024, 8, 12, 12, 30, 0, @local_timezone)
      Time.stubs(:current).returns(local_date.getutc)
      Time.stubs(:now).returns(local_date.getutc)
      Metric.create(name: 'cpu', value: 30, timestamp: '2024-08-10T18:12:55.000Z')
      Metric.create(name: 'cpu', value: 40, timestamp: '2024-08-12T18:12:30.000Z')

      Metrics::Aggregate.new.call('cpu', 'minute')
      cpu_minute_metric = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
      'cpu', 'minute', @start_date, @end_date)
      
      assert_equal 3, cpu_minute_metric.count
      cpu_minute_metric.each_with_index do |cpu_minute_metric, index|
      if index == 0
        assert_equal 2, cpu_minute_metric['count']
        assert_equal '2024-06-30 18:26:59', cpu_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 75.0, cpu_minute_metric['average_value']
        assert_equal 50.0, cpu_minute_metric['min_value']
        assert_equal 100.0, cpu_minute_metric['max_value']
        assert_equal 150.0, cpu_minute_metric['total_value']
        assert_equal '2024-07-01 12:30:00', cpu_minute_metric['created_at'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal '2024-08-10 12:30:00', cpu_minute_metric['updated_at'].strftime("%Y-%m-%d %H:%M:%S")
      elsif index == 1
        assert_equal 2, cpu_minute_metric['count']
        assert_equal '2024-08-10 18:12:59', cpu_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 45.0, cpu_minute_metric['average_value']
        assert_equal 30.0, cpu_minute_metric['min_value']
        assert_equal 60.0, cpu_minute_metric['max_value']
        assert_equal 90.0, cpu_minute_metric['total_value']
        assert_equal '2024-08-10 12:30:00', cpu_minute_metric['created_at'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal '2024-08-12 12:30:00', cpu_minute_metric['updated_at'].strftime("%Y-%m-%d %H:%M:%S")
      elsif index == 2
        assert_equal 1, cpu_minute_metric['count']
        assert_equal '2024-08-12 18:12:59', cpu_minute_metric['timestamp'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal 40.0, cpu_minute_metric['average_value']
        assert_equal 40.0, cpu_minute_metric['min_value']
        assert_equal 40.0, cpu_minute_metric['max_value']
        assert_equal 40.0, cpu_minute_metric['total_value']
        assert_equal '2024-08-12 12:30:00', cpu_minute_metric['created_at'].strftime("%Y-%m-%d %H:%M:%S")
        assert_equal '2024-08-12 12:30:00', cpu_minute_metric['updated_at'].strftime("%Y-%m-%d %H:%M:%S")
      end
    end
  end
end

