class Metrics::Aggregate
    def initialize(metric_repository: MetricRepository.new,
        aggregated_metric_repository: AggregatedMetricRepository.new, 
        aggregation_state_repository: AggregationStateRepository.new)

        @metric_repository = metric_repository
        @aggregated_metric_repository = aggregated_metric_repository
        @aggregation_state_repository = aggregation_state_repository
    end 
    
    def call(name, period)
      aggregate_by_period(name, period)
      @aggregated_metric_repository.find_by_name_and_period(name, period)
    end  
  
    private
  
    def aggregate_by_period(name, period)
      last_aggregated_at = @aggregation_state_repository.find_last_aggregated_at(
        name, @aggregated_metric_repository.periods[period])
      start_time = (last_aggregated_at || @metric_repository.minimum_time_registered_for_metric(name))
      .send("beginning_of_#{period}")
      end_time = @metric_repository.maximum_time_registered_for_metric(name).send("end_of_#{period}")
  
      return if start_time > end_time

      aggregate = @metric_repository.calculate_aggregations_by_name_and_period_in_range(
        name, period, start_time, end_time)

      if aggregate.any?
        @aggregated_metric_repository.upsert_all_aggregated_metric(aggregate)

        @aggregation_state_repository.update_last_aggregated_at(
            name, @aggregated_metric_repository.periods[period], end_time)
      end
    end
  end
  
  