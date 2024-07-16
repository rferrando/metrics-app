
class MetricsAggregationsController < ApplicationController
    before_action :validate_params, only: [:by_minute, :by_hour, :by_day]

    def by_minute
    Metrics::Aggregate.new.call(params[:name], 'minute')
    aggregated_metrics = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
        params[:name], 'minute', params[:start_date], params[:end_date])
    render json: aggregated_metrics
    end
    
    def by_hour
    Metrics::Aggregate.new.call(params[:name], 'hour')
    aggregated_metrics = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
        params[:name], 'hour', params[:start_date], params[:end_date])
    render json: aggregated_metrics
    end

    def by_day
    Metrics::Aggregate.new.call(params[:name], 'day')
    aggregated_metrics = MetricsAggregationRepository.new.find_by_name_and_period_and_date_range(
        params[:name], 'day', params[:start_date], params[:end_date])
    render json: aggregated_metrics
    end

    private
    
    def validate_params
        raise ValidationError.new("Metric name not found") unless MetricRepository.new.names.include?(params[:name])
        raise ValidationError.new("Start date can't be blank" ) if params[:start_date].blank?
        raise ValidationError.new("End date can't be blank" ) if params[:end_date].blank?
        raise ValidationError.new("Start date can be greater than End date" ) unless valid_date_range(params[:start_date], params[:end_date])
    end

    def valid_date_range(start_date, end_date)
        start_date.to_time() < end_date.to_time()
    end    
end
  