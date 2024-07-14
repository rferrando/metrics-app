class MetricsController < ApplicationController

  def create
    metric = MetricRepository.new.create(metric_params)
    render json: metric['response'], status: metric['status']
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :value, :timestamp)
  end
end
