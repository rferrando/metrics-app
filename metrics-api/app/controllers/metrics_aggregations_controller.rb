
class MetricsAggregationsController < ApplicationController
    def by_minute
    aggregated_metrics = Metrics::Aggregate.new.call(params[:name], 'minute', params[:start_date], params[:end_date])
    render json: aggregated_metrics
    end
    
    def by_hour
    aggregated_metrics = Metrics::Aggregate.new.call(params[:name], 'hour', params[:start_date], params[:end_date])
    render json: aggregated_metrics
    end

    def by_day
    aggregated_metrics = Metrics::Aggregate.new.call(params[:name], 'day', params[:start_date], params[:end_date])
    render json: aggregated_metrics
    end
end
  