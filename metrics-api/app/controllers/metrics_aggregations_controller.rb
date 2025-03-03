class MetricsAggregationsController < ApplicationController
    before_action :validate_params, only: [:by_minute, :by_hour, :by_day]

    def initialize(metric_repository: MetricRepository.new,
        metrics_aggregation_repository: MetricsAggregationRepository.new, 
        aggregation_state_repository: AggregationStateRepository.new)
        @metric_repo = metric_repository
        @metrics_aggregation_repo = metrics_aggregation_repository
        @aggregation_state_repo = aggregation_state_repository
      end

    def by_minute  
        Metrics::Aggregate.new(metric_repository: @metric_repo, metrics_aggregation_repository: @metrics_aggregation_repo, 
        aggregation_state_repository: @aggregation_state_repo).call(params[:name], 'minute')
        aggregated_metrics = @metrics_aggregation_repo.find_by_name_and_period_and_date_range(
            params[:name], 'minute', to_begin_of_day(params[:start_date]), to_begin_of_next_day(params[:end_date]))
        render json: aggregated_metrics
    end
    
    def by_hour
        Metrics::Aggregate.new(metric_repository: @metric_repo, metrics_aggregation_repository: @metrics_aggregation_repo, 
        aggregation_state_repository: @aggregation_state_repo).call(params[:name], 'hour')
        aggregated_metrics = @metrics_aggregation_repo.find_by_name_and_period_and_date_range(
            params[:name], 'hour', to_begin_of_day(params[:start_date]), to_begin_of_next_day(params[:end_date]))
        render json: aggregated_metrics
    end

    def by_day
        Metrics::Aggregate.new(metric_repository: @metric_repo, metrics_aggregation_repository: @metrics_aggregation_repo, 
        aggregation_state_repository: @aggregation_state_repo).call(params[:name], 'day')
        aggregated_metrics = @metrics_aggregation_repo.find_by_name_and_period_and_date_range(
            params[:name], 'day', to_begin_of_day(params[:start_date]), to_begin_of_next_day(params[:end_date]))
        render json: aggregated_metrics
    end

    private

    def to_begin_of_day(date_str)
        date_str.to_time().beginning_of_day
    end

    def to_begin_of_next_day(date_str)
        (date_str.to_time + 1.days).end_of_day
    end
    
    def validate_params
        params.require(:name)
        params.require(:start_date)
        params.require(:end_date)

        raise ValidationError.new("Start date can not be greater than End date" ) unless valid_date_range(params[:start_date], params[:end_date])
    end

    def valid_date_range(start_date, end_date)
        start_date.to_time() <= end_date.to_time()
    end    
end
  