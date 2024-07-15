class MetricsController < ApplicationController

  def create
    metric = MetricRepository.new.create(metric_params)
    render json: metric
  end

  def generate_random_data
    num_metrics = params[:num_metrics].to_i
    random_metrics = Metrics::GenerateRandomData.new.call(num_metrics)
    render json: random_metrics
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :value, :timestamp)
  end
end
