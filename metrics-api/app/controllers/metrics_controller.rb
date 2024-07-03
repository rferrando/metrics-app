class MetricsController < ApplicationController

  def index
    @metrics = Metric.select('timestamp AS period, name, value as average_value')
    render json:  format_aggregated_data(@metrics)
  end

  def create
    @metric = Metric.new(metric_params)
    if @metric.save
      render json: @metric, status: :created
    else
      render json: @metric.errors, status: :unprocessable_entity
    end
  end

  def by_minute
    @metrics = Metric.by_minute
    render json: format_aggregated_data(@metrics)
  end

  def by_hour
    @metrics = Metric.by_hour
    render json: format_aggregated_data(@metrics)
  end

  def by_day
    @metrics = Metric.by_day
    render json: format_aggregated_data(@metrics)
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :value)
  end

  def format_aggregated_data(metrics)
    #iterate over each element and build a hash
    metrics_hash = metrics.each_with_object({}) do |metric, hash|
      name = metric.name
      hash[name] ||= []
      hash[name] << { period: metric.period, average_value: metric.average_value }
    end
    return metrics_hash
  end
end
