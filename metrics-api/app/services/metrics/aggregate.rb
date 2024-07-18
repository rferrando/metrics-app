class Metrics::Aggregate
  def initialize(metric_repository: MetricRepository.new,
      metrics_aggregation_repository: MetricsAggregationRepository.new, 
      aggregation_state_repository: AggregationStateRepository.new)

      @metric_repository = metric_repository
      @metrics_aggregation_repository = metrics_aggregation_repository
      @aggregation_state_repository = aggregation_state_repository
  end 
  
  def call(name, period)
    aggregate_by_period(name, period)
  end  

  private

  def aggregate_by_period(name, period)
    last_aggregated_at = @aggregation_state_repository.find_last_aggregated_at(
      name, @metrics_aggregation_repository.periods[period])
    last_registered_metric = @metric_repository.maximum_time_registered_for_metric(name)
    
    return if last_aggregated_at && last_aggregated_at >= last_registered_metric # no metrics pending to be aggregated

    start_time = (last_aggregated_at || @metric_repository.minimum_time_registered_for_metric(name))

    return unless start_time # no metrics found for the period

    start_time = start_time.send("beginning_of_#{period}")
    end_time = last_registered_metric.send("end_of_#{period}")

    aggregate = @metric_repository.calculate_aggregations_by_name_and_period_in_range(
      name, period, start_time, end_time)

    if aggregate.any?
      @metrics_aggregation_repository.upsert_all_aggregated_metric(aggregate)

      @aggregation_state_repository.update_last_aggregated_at(
          name, @metrics_aggregation_repository.periods[period], last_registered_metric)
    end
  end
end
  