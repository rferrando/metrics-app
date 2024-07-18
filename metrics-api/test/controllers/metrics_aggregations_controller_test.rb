require 'test_helper'
class MockedAggregationStateRepository
  def find_last_aggregated_at(name, period)
    nil
  end

  def update_last_aggregated_at(name, period, last_aggregated_at)
    []
  end
end

class MockedMetricsAggregationRepository
  def find_by_name_and_period_and_date_range(name, period, start_date, end_date)
    @data
  end

  def periods
    {minute: 0, hour: 1, day: 2}
  end
  
  def upsert_all_aggregated_metric(data)
    @data = data
  end  
end

class MockedMetricRepository
  def create(attributes)
    {id: 1}.merge(attributes)
  end
  
  def names
    ['cpu']
  end

  def minimum_time_registered_for_metric(name)
    '2024-07-15T22:00:00.000Z'.to_time()
  end

  def maximum_time_registered_for_metric(name)
    '2024-07-15T22:00:00.000Z'.to_time()
  end

  def calculate_aggregations_by_name_and_period_in_range(name, period, start_time, end_time)
    [{id: 1,
    name: 'cpu',
    period: 'minute',
    timestamp: '2024-07-15T22:00:00.000Z'.to_time(),
    average_value: 45.05,
    min_value: 30,
    max_value: 60.1,
    total_value: 90.1,
    count: 2,
    created_at: '2024-07-15T22:00:00.000Z'.to_time(),
    updated_at: '2024-07-15T22:00:00.000Z'.to_time()
  }]
  end
end

class MetricsAggregationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @controller = MetricsAggregationsController.new(metric_repository: MockedMetricRepository.new,
    metrics_aggregation_repository: MockedMetricsAggregationRepository.new, 
    aggregation_state_repository: MockedAggregationStateRepository.new)

    MetricsAggregationsController.stubs(:new).returns(@controller )
  end

  test "should get metrics by minute" do
    get by_minute_metrics_aggregations_url , params: { name: 'cpu', start_date: Time.current, end_date: Time.current }, headers: { }
    assert_response :success
    assert_includes @response.body, {id: 1,
      name: 'cpu',
      period: 'minute',
      timestamp: '2024-07-15T22:00:00.000Z'.to_time(),
      average_value: 45.05,
      min_value: 30,
      max_value: 60.1,
      total_value: 90.1,
      count: 2,
      created_at: '2024-07-15T22:00:00.000Z'.to_time(),
      updated_at: '2024-07-15T22:00:00.000Z'.to_time()
  }.to_json
  end
end