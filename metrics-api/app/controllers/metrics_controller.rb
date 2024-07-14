class MetricsController < ApplicationController

  def create
    metric = MetricRepository.new.create(metric_params)
    render json: metric['response'], status: metric['status']
  end

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

  private

  def metric_params
    params.require(:metric).permit(:name, :value, :timestamp)
  end
end
