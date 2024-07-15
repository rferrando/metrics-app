class MetricsController < ApplicationController

  def create
    metric = MetricRepository.new.create(metric_params)
    render json: metric['response'], status: metric['status']
  end

  def generate_random_data
    num_metrics = params[:num_metrics].to_i
    random_metrics = Metrics::GenerateRandomData.new.call(num_metrics)
    render json: { message: "#{num_metrics} random metrics generated successfully." }
    rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def metric_params
    params.require(:metric).permit(:name, :value, :timestamp)
  end
end
